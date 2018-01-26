require 'rails_helper'

RSpec.describe BackOrdersController, type: :controller do

  describe "GET #index" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
    let!(:back_order1) { FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id) }
    let!(:back_order2) { FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id) }
  
    subject { get :index, {} }
    
    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Planner" do
      before(:each) do
        @planner = FactoryBot.create(:method_engineer_user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @planner.id)
        add_jwt_header(request, @planner)
      end

      it "returns a success response if login" do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of back order" do
        # There should be 2 back_orders inside the database, and the user can only access one of them.
        subject
        result = assigns(:back_orders)
        expect(result.count).to eq(1)
        expect(result).to include(back_order1)
        expect(result).not_to include(back_order2)
      end
    end
  end
  
  describe "GET #show" do
    context "for anonymous user" do
      it "returns a failed response without login" do
        back_order = FactoryBot.create(:back_order)
        get :show, params: { :id => back_order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
      let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
      let!(:back_order1) { FactoryBot.create(:back_order, contract: contract1) }
      let!(:back_order2) { FactoryBot.create(:back_order, contract: contract2) }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns back_order1" do
        get :show, params: { :id => back_order1.id }
        result = assigns(:back_order)
        expect(result).to eq(back_order1)
      end

      it "returns back_order2" do
        get :show, params: { :id => back_order2.id }
        result = assigns(:back_order)
        expect(result).to eq(back_order2)
      end
    end
  end
end