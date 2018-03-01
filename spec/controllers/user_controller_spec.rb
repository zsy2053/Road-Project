require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "GET #index" do
    let(:site) { FactoryBot.create(:site) }
    let!(:user1) { FactoryBot.create(:supervisor_user, site: site) }
    let!(:user2) { FactoryBot.create(:super_admin_user, site: site) }
    subject { get :index, {} }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for super admin" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, site: site)
        add_jwt_header(request, @super_admin)
      end

      it "returns a success response if login" do
        subject
        expect(response). to have_http_status(:success)
      end

      it "returns correct number of users" do
        subject
        result = assigns(:users)
        expect(result).to include(user1)
        expect(result).to include(user2)
        expect(result).to include(@super_admin)
        expect(result.count). to eq(3)
      end
    end

    context "for admin" do
      before(:each) do
        @admin = FactoryBot.create(:admin_user, site: site)
        add_jwt_header(request, @admin)
      end

      it "returns a success response if login" do
        subject
        expect(response). to have_http_status(:success)
      end

      it "returns correct number of users" do
        subject
        result = assigns(:users)
        expect(result).to include(user1)
        expect(result).not_to include(user2)
        expect(result).to include(@admin)
        expect(result.count). to eq(2)
      end
    end
  end

  describe "GET #show" do
    let(:site) { FactoryBot.create(:site) }
    let!(:user1) { FactoryBot.create(:supervisor_user, site: site) }
    let!(:user2) { FactoryBot.create(:super_admin_user, site: site) }

    context "for anonymous user" do
      it "returns unauthorized" do
        get :show, params: { id: user1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for super admin" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, site: site)
        add_jwt_header(request, @super_admin)
      end

      it "returns regular user" do
        get :show, params: { id: user1.id }
        expect(response). to have_http_status(:success)
      end

      it "returns super admin" do
        get :show, params: { id: user2.id }
        expect(response). to have_http_status(:success)
      end
    end

    context "for admin" do
      before(:each) do
        @admin = FactoryBot.create(:admin_user, site: site)
        add_jwt_header(request, @admin)
      end

      it "returns regular user" do
        get :show, params: { id: user1.id }
        expect(response). to have_http_status(:success)
      end

      it "doesn't return super admin" do
        get :show, params: { id: user2.id }
        expect(response). to have_http_status(:forbidden)
      end
    end
  end

  describe "POST #create" do
    let(:site) { FactoryBot.create(:site) }
    
    let(:valid_attributes) {
      { username: "admin1", password: "Qwer1234", email: "test123@gmail.com", site_id: site.id, role: "super_admin", first_name: "testname", last_name: "testlast", employee_id: "654322", phone: "640154568", site_name_text: "Oshawa" }
    }
    
    let(:invalid_attributes) {
      { username: '' }
    }

    context "for anonymous user" do
      it "returns unauthorized" do
        get :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for super admin" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, site: site)
        add_jwt_header(request, @super_admin)
      end

      it "post succeed when post with valid attributes" do
        post :create, params: {user: valid_attributes}
        expect(response). to have_http_status(:created)
      end

      it "post failed when post with invalid attributes" do
        post :create, params: {user: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      context "with contracts" do
        let!(:contract) { FactoryBot.create(:contract, site: site) }
        let(:valid_attributes_with_contract) {
          { username: "admin1",
            password: "Qwer1234",
            email: "test123@gmail.com",
            site_id: site.id, 
            role: "super_admin", 
            first_name: "testname", 
            last_name: "testlast", 
            employee_id: "654322", 
            phone: "640154568",
            contract_ids: [ contract.id ],
            site_name_text: 'Oshawa'
          }
        }
        
        before(:each) do
          expect(User.where(username: "admin1")).to be_empty
        end
        
        subject { post :create, params: { user: valid_attributes_with_contract } }
        
        it "succeeds" do
          subject
          expect(response).to have_http_status(:created)
        end
        
        it "adds a user" do
          expect { subject }.to change{ User.count }.by(1)
          result = User.last
          expect(result.username).to eq("admin1")
        end
        
        it "adds an access" do
          expect { subject }.to change{ Access.count }.by(1)
          result = Access.last
          expect(result.user).to eq(User.last)
          expect(result.contract_id).to eq(contract.id)
        end
      end
    end

    context "for admin" do
      before(:each) do
        @admin = FactoryBot.create(:admin_user, site: site)
        add_jwt_header(request, @admin)
      end

      it "post failed when post with valid attributes but super_admin role" do
        post :create, params: {user: valid_attributes}
        expect(response). to have_http_status(:forbidden)
      end

      it "post failed when post with invalid attributes" do
        post :create, params: {user: invalid_attributes}
        expect(response). to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:site) { FactoryBot.create(:site) }
    let!(:user) { FactoryBot.create(:supervisor_user, first_name: "first 1", last_name: "last 1") }
    
    let(:valid_attributes) {
      { first_name: "first 2", last_name: "last 2", ignore_password: true }
    }
    
    let(:invalid_attributes) {
      { username: '', ignore_password: true }
    }

    context "for anonymous user" do
      it "returns unauthorized" do
        patch :update, params: { :id => user.id, :user => valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for super admin" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, site: site)
        add_jwt_header(request, @super_admin)
      end

      it "post succeed when post with valid attributes" do
        patch :update, params: {:id => user.id, :user => valid_attributes}
        expect(response).to have_http_status(:ok)
      end

      it "post failed when post with invalid attributes" do
        patch :update, params: {:id => user.id, :user => invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      context "with contracts" do
        let!(:contract1) { FactoryBot.create(:contract, site: site) }
        let!(:contract2) { FactoryBot.create(:contract, site: site) }
        let!(:contract3) { FactoryBot.create(:contract, site: site) }
        let!(:access1) { FactoryBot.create(:access, contract: contract1, user: user)}
        let!(:access2) { FactoryBot.create(:access, contract: contract2, user: user)}
        let(:valid_attributes_with_contract) {
          { first_name: "first 2",
            last_name: "last 2",
            ignore_password: true,
            contract_ids: [ contract2.id, contract3.id ]
          }
        }
        
        subject { patch :update, params: { :id => user.id, :user => valid_attributes_with_contract } }

        it "succeeds" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "updates the user" do
          subject
          result = User.find_by_id(user.id)
          expect(result.first_name).to eq("first 2")
          expect(result.last_name).to eq("last 2")
        end
        
        it "modifies access records" do
          subject
          expect(Access.find_by(user: user, contract: contract3)).to be_present
          expect(Access.find_by(user: user, contract: contract2)).to be_present
          expect(Access.find_by(user: user, contract: contract1)).to_not be_present
        end
      end
      
      context "remove all contract associations" do
        let!(:contract1) { FactoryBot.create(:contract, site: site) }
        let!(:contract2) { FactoryBot.create(:contract, site: site) }
        let!(:contract3) { FactoryBot.create(:contract, site: site) }
        let!(:access1) { FactoryBot.create(:access, contract: contract1, user: user)}
        let!(:access2) { FactoryBot.create(:access, contract: contract2, user: user)}
        let!(:access3) { FactoryBot.create(:access, contract: contract3, user: user)}
        let(:valid_attributes_with_contract) {
          { first_name: "first 2",
            last_name: "last 2",
            ignore_password: true,
            'contract_ids[]' => '' # if not written this way, Rails will ignore the param
          }
        }
        
        subject { patch :update, params: { :id => user.id, :user => valid_attributes_with_contract } }

        it "succeeds" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "updates the user" do
          subject
          result = User.find_by_id(user.id)
          expect(result.first_name).to eq("first 2")
          expect(result.last_name).to eq("last 2")
        end
        
        it "modifies access records" do
          expect(user.contract_ids.length).to eq(Access.all.length)
          expect(Access.find_by(user: user, contract: contract3)).to be_present
          expect(Access.find_by(user: user, contract: contract2)).to be_present
          expect(Access.find_by(user: user, contract: contract1)).to be_present
          
          subject
          
          expect(Access.find_by(user: user, contract: contract3)).to_not be_present
          expect(Access.find_by(user: user, contract: contract2)).to_not be_present
          expect(Access.find_by(user: user, contract: contract1)).to_not be_present
        end
      end
    end
  end
end
