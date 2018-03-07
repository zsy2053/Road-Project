require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  describe "GET #index" do
    let!(:car_road_order) { FactoryBot.create(:car_road_order) }
    let(:road_order) { car_road_order.road_order }
    let(:contract) { road_order.contract }
    let!(:definition1) { FactoryBot.create(:definition, road_order: road_order) }
    let!(:definition2) { FactoryBot.create(:definition, road_order: road_order) }
    let!(:movement1) { FactoryBot.create(:movement, definition: definition1, car_road_order: car_road_order) }
    let!(:movement2) { FactoryBot.create(:movement, definition: definition2, car_road_order: car_road_order) }
    let!(:site) { contract.site }
    let!(:work1) { FactoryBot.create(:work, :contract => contract, :parent => movement1) }
    let!(:work2) { FactoryBot.create(:work, :contract => contract, :parent => movement2) }

    subject { get :index, {} }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authorized user" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        FactoryBot.create(:access, :contract_id => contract.id, :user_id => @method_engineer.id)
        add_jwt_header(request, @method_engineer)
      end

      it "returns a success response if login" do
        subject
        expect(response). to have_http_status(:success)
      end

      it "should filter the work records if the movement id is provided" do
        get :index, params: { movement_id: movement1.id }
        result = assigns(:work_records)
        expect(result.count).to eq(1)
        expect(result).to include(work1)
        expect(result).not_to include(work2)
      end

      it "returns correct number of work records" do
        subject
        result = assigns(:work_records)
        expect(result.count). to eq(2)
        expect(result).to include(work1)
        expect(result).to include(work2)
      end
    end
  end

  describe "GET #show" do
    let!(:movement) { FactoryBot.create(:movement) }
    let!(:contract) { movement.definition.road_order.contract }
    let!(:site) { contract.site }
    let!(:work1) { FactoryBot.create(:work, :contract => contract, :parent => movement) }

    context "for anonymous user" do
      it "returns unauthorized" do
        get :show, params: { id: work1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authorized user" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        FactoryBot.create(:access, :contract_id => contract.id, :user_id => @method_engineer.id)
        add_jwt_header(request, @method_engineer)
      end

      it "returns a success response if login" do
        get :show, params: { id: work1.id }
        expect(response).to have_http_status(:success)
      end

      it "returns correct work records" do
        get :show, params: { id: work1.id }
        result = assigns(:work_record)
        expect(result.id).to eq(work1.id)
      end
    end
  end

  describe "POST #create" do
    let!(:movement) { FactoryBot.create(:movement) }
    let!(:car_road_order) { movement.car_road_order }
    let!(:contract) { movement.definition.road_order.contract }
    let!(:site) { contract.site }
    let!(:position) { FactoryBot.create(:position, car_road_order: car_road_order) }
    let!(:operator) { FactoryBot.create(:operator, site: site) }
    
    let(:valid_attributes) {
      {
        operator_id: operator.id,
        actual_time: Time.now,
        override_time: Time.now,
        action: "Start",
        parent_type: "Movement",
        position: position.name,
        parent_id: movement.id
      }
    }

    let(:invalid_attributes) {
      { operator_id: '' }
    }

    context "for anonymous user" do
      it "returns unauthorized" do
        post :create, params: { work: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for user without writing permission" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        FactoryBot.create(:access, :contract_id => contract.id, :user_id => @method_engineer.id)
        add_jwt_header(request, @method_engineer)
      end

      it "should be forbidden" do
        post :create, params: { work: valid_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "for authenticated user" do
      before(:each) do
        @station_user = FactoryBot.create(:station_user, :site => site)
        FactoryBot.create(:access, :contract_id => contract.id, :user_id => @station_user.id)
        add_jwt_header(request, @station_user)
      end

      it "post failed when post with invalid attributes" do
        post :create, params: { work: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "post success with valid attributes" do
        post :create, params: { work: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it "return correct object of operator" do
        post :create, params: { work: valid_attributes }
        result = assigns(:work_record)
        expect(result.operator).to eq(operator)
        # compare times as timestamps removing fractional component
        expect(result.actual_time.to_f.floor).to eq(valid_attributes[:actual_time].to_f.floor)
        expect(result.override_time.to_f.floor).to eq(valid_attributes[:override_time].to_f.floor)
        expect(result.action).to eq("Start")
        expect(result.parent).to eq(movement)
        expect(result.position).to eq(position.name)
        expect(result.contract).to eq(contract)
      end
    end
  end
end
