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

end
