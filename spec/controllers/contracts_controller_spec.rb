require 'rails_helper'

RSpec.describe ContractsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Contract. As you add validations to Contract, be sure to
  # adjust the attributes here as well.

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContractsController. Be sure to keep this updated too.

  describe "GET #index" do
    context "for anonymous user" do
      it "returns a failed response without login" do
        get :index, {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads contracts based on access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let!(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
      let!(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
      subject { get :index, {} }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns all contracts." do
        # There should be 2 contracts inside the database, and the user can only access one of them.
        subject
        result = assigns(:contracts)
        expect(result.count).to eq(2)
        expect(result).to eq([contract1, contract2])
      end

      it "returns correct json of contract join with station and contract." do
        subject
        result = JSON.parse(response.body)
        expect(result[0]['name']).to eq('Nasa')
        expect(result[0]['status']).to eq('draft')
        expect(result[1]['name']).to eq('Tesla')
        expect(result[1]['status']).to eq('open')
      end
    end
  end

  describe "GET #show" do
    context "for anonymous user" do
      let(:contract) { FactoryBot.create(:contract) }
      it "returns a failed response without login" do
        get :show, params: { :id => contract.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for station user" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end
    context "for Method Engineer" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads contract by id based on access" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let!(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
      let!(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns contract1." do
        get :show, params: { :id => contract1.id }
        result = assigns(:contract)
        expect(result).to eq(contract1)
      end

      it "returns contract2." do
        get :show, params: { :id => contract2.id }
        result = assigns(:contract)
        expect(result).to eq(contract2)
      end

      it "returns correct json of contract join with station and contract." do
        get :show, params: { :id => contract1.id }
        result = JSON.parse(response.body)
        expect(result['name']).to eq('Nasa')
        expect(result['status']).to eq('draft')
      end
    end
  end

  describe "POST #create" do
    let(:site) {FactoryBot.create(:site)}
    let(:valid_attributes) { { :site_id => site.id, :minimum_offset => 4, :status => 'draft' } }
    subject { post :create, params: { :contract => valid_attributes } }

    context "for anonymous user" do
      it "returns a failed response without login" do
        post :create, params: { :contract => valid_attributes }
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
      let(:attributes_with_wrong_status) { {:site_id => site.id, :status => "on_fire" } }

      before(:each) do
        @user = FactoryBot.create(:super_admin_user, :site_id => site.id)
        add_jwt_header(request, @user)
      end
      it "throws an ActionController::ParameterMissing error by sending empty attributes if login a user with ability :create to contract." do
        expect{ post :create, params: { :contract => empty_attributes } }.to raise_error(ActionController::ParameterMissing)
      end

      it  "throws an ArgumentError error by sending wrong attribute status(other than open, closed and draft) if login a user with ability :create to contract." do
        expect{ post :create, params: { :contract => attributes_with_wrong_status } }.to raise_error(ArgumentError)
      end

      it "generates new contract record by sending valid attributes if login a user with ability :create to contract." do
        expect{ post :create, params: { :contract => valid_attributes } }.to change(Contract, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end
  end

  describe "PUT #update" do
    let(:site) { FactoryBot.create(:site) }
    let!(:contract) { FactoryBot.create(:contract) }
    let(:valid_attributes) { { :id => contract.id, :site_id => site.id, :name => "T_T", :minimum_offset => 4 } }
    subject { put :update, params: { :id => contract.id, :contract => valid_attributes } }

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
      let(:attributes_with_wrong_status) { { :id => contract.id, :site_id => site.id, :status => "on_fire" } }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "throws an ActionController::ParameterMissing error by sending empty attributes if login a user with ability :update to contract." do
        expect{ put :update, params: {:id => contract.id, :contract => empty_attributes } }.to raise_error(ActionController::ParameterMissing)
      end

      it  "throws an ArgumentError error by sending wrong attribute status(other than open, closed and draft) if login a user with ability :update to contract." do
        expect{ put :update, params: { :id => contract.id, :contract => attributes_with_wrong_status } }.to raise_error(ArgumentError)
      end

      it "updates a contract record by sending valid attributes if login a user with ability :update to contract." do
        expect(contract.name).to be_nil
        contract_id = contract.id
        put :update, params: {:id => contract_id, :contract => valid_attributes }
        expect(Contract.find(contract_id).name).to eq("T_T")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:contract_id) { nil }
    let!(:contract) { FactoryBot.create(:contract) }
    subject { delete :destroy, params: { :id => contract_id } }

    context "for anonymous user" do
      let(:contract_id) { contract.id }
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for Supervisor" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for planner" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:planner_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for station" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:station_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for quality" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:quality_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for admin" do
      it_behaves_like "has no ability for this action" do
        let(:one_user) { FactoryBot.create(:admin_user) }
        let(:contract) { FactoryBot.create(:contract) }
        let(:contract_id) { contract.id }
      end
    end

    context "for super_admin" do
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "updates a contract record by sending valid attributes if login a user with ability :destroy to contract." do
        expect{ delete :destroy, params: { :id => contract.id } }.to change(Contract, :count).by(-1)
      end

    end
  end
end


