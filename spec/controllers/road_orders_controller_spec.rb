require 'rails_helper'

RSpec.describe RoadOrdersController, type: :controller do

  describe "GET #index" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
    let!(:road_order1) { FactoryBot.create(:road_order, :station_id => station1.id, :car_type => "A", :start_car => 1) }
    let!(:road_order2) { FactoryBot.create(:road_order, :station_id => station2.id, :car_type => "B", :start_car => 2) }
  
    subject { get :index, {} }
    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(401)
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
        expect(response).to have_http_status(200)
      end

      it "returns correct number of road order." do
        # There should be 2 road_orders inside the database, and the user can only access one of them.
        subject
        result = assigns(:road_orders)
        expect(result.count).to eq(1)
        expect(result).to include(road_order1)
        expect(result).not_to include(road_order2)
      end

      it "returns correct json of road order join with station and contract." do
        subject
        result = JSON.parse(response.body)[0]
        expect(result['car_type']).to eq('A')
        expect(result['start_car']).to eq(1)
        expect(result['station']).to_not be_nil
        expect(result['station']['name']).to eq('station 1')
        expect(result['contract']).to_not be_nil
        expect(result['contract']['name']).to eq('contract 1')
      end
    end
  end

  describe "GET #show" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:road_order1) { FactoryBot.create(:road_order, :station_id => station1.id, :car_type => "A", :start_car => 1) }
    
    context "To get the detail about the road order" do
      before(:each) do
        @user = FactoryBot.create(:user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
        add_jwt_header(request, @user)
      end

      it "returns the corresponding road order." do
        get :show, params: {id: road_order1.id}
        result = JSON.parse(response.body)
        expect(result['car_type']). to eq('A')
        expect(result['start_car']). to eq(1)
        expect(result['station']). to_not be_nil
        expect(result['station']['name']).to eq('station 1')
        expect(result['contract']).to_not be_nil
        expect(result['contract']['name']).to eq('contract 1')
      end
    end
  end
end
