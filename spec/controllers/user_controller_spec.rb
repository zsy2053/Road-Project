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
      { username: "admin1", password: "Qwer1234", email: "test123@gmail.com", site_id: site.id, role: "super_admin", first_name: "testname", last_name: "testlast", employee_id: "654322", phone: "640154568" }
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
        expect(response). to have_http_status(:unprocessable_entity)
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
end
