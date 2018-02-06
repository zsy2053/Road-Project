require 'rails_helper'

RSpec.describe StationsController, type: :controller do
  describe "GET #index" do
    context "for anonymous user" do
      it "returns a failed response without login" do
        get :index, {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads stations based on contract access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let!(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status => "draft") }
      let!(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status => "open") }
      let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "King") }
      let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "Queen") }
      subject { get :index, {} }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns all stations." do
        # There should be 2 stations inside the database, and the user can only access one of them.
        subject
        result = assigns(:stations)
        expect(result.count).to eq(2)
        expect(result).to eq([station1, station2])
      end

      it "returns correct json of station join with station and station." do
        subject
        result = JSON.parse(response.body)
        expect(result[0]['name']).to eq('King')
        expect(result[0]['contract_id']).to eq(contract1.id)
        expect(result[1]['name']).to eq('Queen')
        expect(result[1]['contract_id']).to eq(contract2.id)
      end
    end
  end

  describe "GET #show" do
    context "for anonymous user" do
      let(:station) { FactoryBot.create(:station) }
      it "returns a failed response without login" do
        get :show, params: { :id => station.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for station user" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end
    context "for Method Engineer" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads station by id based on contract access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do

      let(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
      let(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
      let(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "King") }
      let(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "Queen") }

      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns station1." do
        get :show, params: { :id => station1.id }
        result = assigns(:station)
        expect(result).to eq(station1)
      end

      it "returns station2." do
        get :show, params: { :id => station2.id }
        result = assigns(:station)
        expect(result).to eq(station2)
      end

      it "returns correct json of station join with station and station." do
        get :show, params: { :id => station1.id }
        result = JSON.parse(response.body)
        expect(result['name']).to eq('King')
        expect(result['contract_id']).to eq(contract1.id)
      end
    end
  end

  describe "POST #create" do
    let(:contract) {FactoryBot.create(:contract)}
    let(:valid_attributes) { FactoryBot.attributes_for(:station, :contract_id => contract.id) }
    subject { post :create, params: { :station => valid_attributes } }

    context "for anonymous user" do
      it "returns a failed response without login" do
        post :create, params: { :station => valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
        let(:attributes) { valid_attributes }
      end
    end

    context "for planner" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:planner_user) }
        let(:attributes) { valid_attributes }
      end
    end

    context "for station" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:station_user) }
        let(:attributes) { valid_attributes }
      end
    end

    context "for quality" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:quality_user) }
        let(:attributes) { valid_attributes }
      end
    end

    context "for admin" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:admin_user) }
        let(:attributes) { valid_attributes }
      end
    end

    context "for super_admin" do
      let(:empty_attributes) { nil }

      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end
      it "throws an ActionController::ParameterMissing error by sending empty attributes if login a user with ability :create to station." do
        expect{ post :create, params: { :station => empty_attributes } }.to raise_error(ActionController::ParameterMissing)
      end

      it "generates new station record by sending valid attributes if login a user with ability :create to station." do
        expect{ post :create, params: { :station => valid_attributes } }.to change(Contract, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end
  end

  describe "PUT #update" do
    let(:contract) { FactoryBot.create(:contract) }
    let!(:station) { FactoryBot.create(:station) }
    let(:valid_attributes) { { :id => station.id, :contract_id => contract.id, :name => "Finch", :code => "FC" } }
    subject { put :update, params: { :id => station.id, :station => valid_attributes } }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let(:empty_attributes) { nil }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "throws an ActionController::ParameterMissing error by sending empty attributes if login a user with ability :update to station." do
        expect{ put :update, params: {:id => station.id, :station => empty_attributes } }.to raise_error(ActionController::ParameterMissing)
      end

      it "updates a station record by sending valid attributes if login a user with ability :update to station." do
        expect(station.name).to_not eq("Finch")
        expect(station.code).to_not eq("FC")
        station_id = station.id
        put :update, params: {:id => station_id, :station => valid_attributes }
        expect(Station.find(station_id).name).to eq("Finch")
        expect(Station.find(station_id).code).to eq("FC")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:station_id) { nil }
    let!(:station) { FactoryBot.create(:station) }
    subject { delete :destroy, params: { :id => station_id } }

    context "for anonymous user" do
      let(:station_id) { station.id }
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for Supervisor" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for planner" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:planner_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for station" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:station_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for quality" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:quality_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for admin" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:admin_user) }
        let(:station) { FactoryBot.create(:station) }
        let(:station_id) { station.id }
      end
    end

    context "for super_admin" do
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "deletes the station from the system" do
        expect{ delete :destroy, params: { :id => station.id } }.to change(Station, :count).by(-1)
      end
    end
  end
end
