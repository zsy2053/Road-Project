require 'rails_helper'

RSpec.describe StopReasonsController, type: :controller do
  let!(:site) { FactoryBot.create(:site) }
  describe "GET #index" do
    let!(:stop_reason1) { FactoryBot.create(:stop_reason, :should_alert => true) }
    let!(:stop_reason2) { FactoryBot.create(:stop_reason) }
    context "for anonymous user" do
      it "returns a failed response without login" do
        get :index, {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticate user with access" do
      before(:each) do
        @user = FactoryBot.create(:user, :site => site)
        add_jwt_header(request, @user)
      end

      it "returns a success response" do
        get :index, {}
        expect(response).to have_http_status(:success)
      end

      it "assigns correct object" do
        get :index, {}
        result = assigns(:stop_reasons)
        expect(result.count).to eq(2)
        expect(result.ids).to include(stop_reason1.id)
        expect(result.ids).to include(stop_reason2.id)
      end
    end
  end

  describe "GET #show" do
    let!(:stop_reason1) { FactoryBot.create(:stop_reason, :should_alert => true) }
    let!(:stop_reason2) { FactoryBot.create(:stop_reason) }
    context "for anonymous user" do
      it "returns a failed response without login" do
        get :show, params: { :id => stop_reason1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticate user with access" do
      before(:each) do
        @user = FactoryBot.create(:user, :site => site)
        add_jwt_header(request, @user)
      end

      it "returns a success response" do
        get :show, params: { :id => stop_reason1.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns correct object" do
        get :show, params: { :id => stop_reason1.id }
        result = assigns(:stop_reason)
        expect(result.id).to eq(stop_reason1.id)
        expect(result.id).not_to eq(stop_reason2.id)
      end
    end
  end
end
