require 'rails_helper'

RSpec.describe SitesController, type: :controller do

  describe "GET #index" do
    let!(:site1) { FactoryBot.create(:site, :name => "site 1") }
    let!(:site2) { FactoryBot.create(:site, :name => "site 2") }

    subject { get :index, {} }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authorized non-super admin user" do
      before(:each) do
        @authorized_user = FactoryBot.create(:supervisor_user, :site_id => site1.id)
        add_jwt_header(request, @authorized_user)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns only their own site" do
        # There should be 2 sites inside the database.
        subject
        result = assigns(:sites)
        expect(result.count).to eq(1)
        expect(result).to include(site1)
        expect(result).to_not include(site2)
      end
    end

    context "for authorized super admin user" do
      before(:each) do
        @authorized_user = FactoryBot.create(:super_admin_user, :site_id => site1.id)
        add_jwt_header(request, @authorized_user)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns only their own site" do
        # There should be 2 sites inside the database.
        subject
        result = assigns(:sites)
        expect(result.count).to eq(2)
        expect(result).to include(site1)
        expect(result).to include(site2)
      end
    end
  end
end
