require 'rails_helper'

RSpec.describe RoadOrdersController, type: :controller do

  describe "GET #index" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
    let!(:road_order1) { FactoryBot.create(:road_order, :station_id => station1.id, :car_type => "A", :start_car => 1) }
    let!(:road_order2) { FactoryBot.create(:road_order, :station_id => station2.id, :car_type => "B", :start_car => 1) }
  
    subject { get :index, {} }
    
    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @method_engineer.id)
        add_jwt_header(request, @method_engineer)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of road order." do
        # There should be 2 road_orders inside the database, and the user can only access one of them.
        subject
        result = assigns(:road_orders)
        expect(result.count).to eq(1)
        expect(result).to include(road_order1)
        expect(result).not_to include(road_order2)
      end
    end
  end

  describe "GET #show" do
    # road order the user has access to
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:road_order1) { FactoryBot.create(:road_order, :station_id => station1.id, :car_type => "A", :start_car => 1) }
    
    # arbitrary road order the user does not have access to
    let!(:road_order2) { FactoryBot.create(:road_order) }
    
    context "for anonymous user" do
      it "returns unauthorized" do
        get :show, params: { id: road_order1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context "for authenticated user" do
      before(:each) do
        @user = FactoryBot.create(:user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
        add_jwt_header(request, @user)
      end
      
      it "returns the road order if user has access" do
        get :show, params: { id: road_order1.id }
        expect(response).to have_http_status(:success)
      end

      it "doesn't return the road order if user has no access" do
        get :show, params: { id: road_order2.id }
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the corresponding road order." do
        get :show, params: { id: road_order2.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
  
  describe "POST #create" do
    let(:station) { FactoryBot.create(:station) }
    let(:author) { FactoryBot.create(:user) }
    
    let(:valid_attributes) {
      {
        car_type: 'Coach',
        start_car: 1,
        station_id: station.id,
        file_path: 'file_path',
        work_centre: "Bonding",
        module: "B",
        positions: [ 'A1', 'B1' ],
        definitions_attributes: [
          {
            "name" => "Mvt/Assy",
            "description" => "Description",
            "day" => "1",
            "shift" => "1",
            "work_location" => "Work Location",
            "positions" => [ "B2" ],
            "expected_duration" => "60",
            "breaks" => "0",
            "expected_start" => "08:00:00",
            "expected_end" => "09:00:00",
            "serialized" => 'false'
          }
        ],
        day_shifts: {
        "1" => [
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ],
        "2" =>[
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ]
      }
      }
    }
    
    let(:invalid_attributes) {
      { apple: 'banana' }
    }
    
    context "for anonymous user" do
      it "returns unauthorized" do
        post :create, params: { road_order: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context "for authenticated user" do
      before(:each) do
        @user = author
        add_jwt_header(request, @user)
        
        @ability = Ability.new(@user)
        expect(@controller).to receive(:current_ability).and_return(@ability)
      end
      
      describe "with access" do
        it "accepts valid input" do
          @ability.can :create, RoadOrder
          post :create, params: { road_order: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          
          result = RoadOrder.last
          expect(response.location).to eq(road_order_url(result))
          
          # check road order attributes
          expect(result.car_type).to eq('Coach')
          expect(result.start_car).to eq(1)
          expect(result.station.id).to eq(station.id)
          expect(result.author.id).to eq(author.id)
          # TODO expect(result.file_path).to eq('file_path')
          expect(result.positions).to eq([ 'A1', 'B1' ])
          expect(result.day_shifts).to eq({
            "1" => [
              { "shift" => "1", "start" => "07:00:00", "end" => "13:00:00" },
              { "shift" => "1", "start" => "13:00:00", "end" => "19:00:00" }
            ],
            "2" =>[
              { "shift" => "1", "start" => "07:00:00", "end" => "13:00:00" },
              { "shift" => "1", "start" => "13:00:00", "end" => "19:00:00" }
            ]
          })
          
          definitionResult = Definition.last
          expect(result.definitions.size).to eq(1)
          expect(result.definitions.first).to eq(definitionResult)
          
          # check definition attributes
          expect(definitionResult.name).to eq("Mvt/Assy")
          expect(definitionResult.description).to eq("Description")
          expect(definitionResult.day).to eq("1")
          expect(definitionResult.shift).to eq("1")
          expect(definitionResult.work_location).to eq("Work Location")
          expect(definitionResult.positions).to eq([ "B2" ])
          expect(definitionResult.expected_duration).to eq(60)
          expect(definitionResult.breaks).to eq(0)
          expect(definitionResult.expected_start.to_s).to eq("08:00:00")
          expect(definitionResult.expected_end.to_s).to eq("09:00:00")
          expect(definitionResult.serialized).to eq(false)
        end
        
        it "rejects invalid input" do
          @ability.can :create, RoadOrder
          post :create, params: { road_order: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
      
      describe "without access" do
        it "fails" do
          @ability.cannot :create, RoadOrder
          post :create, params: { road_order: valid_attributes }
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end