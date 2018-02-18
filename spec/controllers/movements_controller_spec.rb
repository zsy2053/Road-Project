require 'rails_helper'

RSpec.describe MovementsController, type: :controller do
  
  describe "GET #show" do
    let!(:contract) { FactoryBot.create(:contract) }
    let!(:other_contract) { FactoryBot.create(:contract) }
   
    let(:road_order) { FactoryBot.create(:road_order, contract: contract, station: FactoryBot.create(:station, contract: contract)) }
    let(:other_road_order) { FactoryBot.create(:road_order, contract: other_contract, station: FactoryBot.create(:station, contract: other_contract)) }
    
    let!(:car_road_order) { FactoryBot.create(:car_road_order, car: FactoryBot.create(:car), road_order: road_order) }
    let!(:other_car_road_order) { FactoryBot.create(:car_road_order, car: FactoryBot.create(:car), road_order: other_road_order) }
    
    let!(:definition) { FactoryBot.create(:definition, road_order: road_order) }
    let!(:other_definition) { FactoryBot.create(:definition, road_order: other_road_order) }
    
    let!(:movement) { FactoryBot.create(:movement, car_road_order: car_road_order, definition: definition) }
    let!(:other_movement) { FactoryBot.create(:movement, car_road_order: other_car_road_order, definition: other_definition) }
    
    context "for anonymous user" do
      it "returns a failed response without login" do
        get :show, params: { :id => movement.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context "for authenticated user" do
      before(:each) do
        @user = FactoryBot.create(:user)
        FactoryBot.create(:access, :contract_id => contract.id, :user_id => @user.id)
        add_jwt_header(request, @user)
      end
      
      it "returns the movement if user has access" do
        get :show, params: { :id => movement.id }
        expect(response).to have_http_status(:success)
      end

      it "doesn't return the movement if user has no access" do
        get :show, params: { id: other_movement.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
    
    context "for super admin user" do
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end
      
      it "returns movement for contract" do
        get :show, params: { :id => movement.id }
        expect(response).to have_http_status(:success)
      end

      it "returns movement for other_contract" do
        get :show, params: { id: other_movement.id }
        expect(response).to have_http_status(:success)
      end

    end
    
  end
  
  describe "PUT #update" do
    let!(:contract) { FactoryBot.create(:contract) }
    let!(:other_contract) { FactoryBot.create(:contract) }
   
    let(:update_road_order) { FactoryBot.create(:road_order, contract: contract, station: FactoryBot.create(:station, contract: contract)) }
    let(:other_update_road_order) { FactoryBot.create(:road_order, contract: other_contract, station: FactoryBot.create(:station, contract: other_contract)) }
    
    let!(:update_car_road_order) { FactoryBot.create(:car_road_order, car: FactoryBot.create(:car), road_order: update_road_order) }
    let!(:other_update_car_road_order) { FactoryBot.create(:car_road_order, car: FactoryBot.create(:car), road_order: other_update_road_order) }
    
    let!(:update_definition) { FactoryBot.create(:definition, road_order: update_road_order) }
    let!(:other_update_definition) { FactoryBot.create(:definition, road_order: other_update_road_order) }
    
    let!(:update_movement) { FactoryBot.create(:movement, car_road_order: update_car_road_order, definition: update_definition, quality_critical: true, production_critical: true) }
    let!(:other_update_movement) { FactoryBot.create(:movement, car_road_order: other_update_car_road_order, definition: other_update_definition, quality_critical: false, production_critical: false) }
    
    let(:valid_attributes) { { :id => update_movement.id, :production_critical => false } }
    
    subject { put :update, params: { :id => update_movement.id, :movement => valid_attributes } }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
        let(:one_user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for planner" do
      it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
        let(:one_user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
        let(:one_user) { FactoryBot.create(:station_user) }
      end
    end

    context "for admin" do
      it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
        let(:one_user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
        let(:one_user) { FactoryBot.create(:super_admin_user) }
      end
    end
    
    context "for Supervisor" do
      
      it_behaves_like "can update production_critical attribute of movements for their contracts" do
        let(:one_user) { FactoryBot.create(:supervisor_user) }
        let(:update_attributes) { { :production_critical => false } }
        subject { put :update, params: { :id => update_movement.id, :movement => update_attributes } }
      end
      
      context "cannot update production_critical of movements for other contracts" do
        it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
          let(:one_user) { FactoryBot.create(:supervisor_user) }
          let(:update_attributes) { { :production_critical => false } }
          subject { put :update, params: { :id => other_update_movement.id, :movement => update_attributes } }
        end
      end
      
      context "cannot update other attributes of movements for their contracts" do
        it_behaves_like "cannot update this attribute" do
          let(:one_user) { FactoryBot.create(:supervisor_user) }
          let(:update_attributes) { { :quality_critical => true } }
          subject { put :update, params: { :id => update_movement.id, :movement => update_attributes } }
        end
      end
      
      context "cannot update other attributes of movements for other contracts" do
        it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
          let(:one_user) { FactoryBot.create(:supervisor_user) }
          let(:update_attributes) { { :quality_critical => true } }
          subject { put :update, params: { :id => other_update_movement.id, :movement => update_attributes } }
        end
      end
    end
    
    context "for quality" do
      
      it_behaves_like "can update quality_critical attribute of movements for their contracts" do
        let(:one_user) { FactoryBot.create(:quality_user) }
        let(:update_attributes) { { :quality_critical => false } }
        subject { put :update, params: { :id => update_movement.id, :movement => update_attributes } }
      end
      
      context "cannot update quality_critical of movements for other contracts" do
        it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
          let(:one_user) { FactoryBot.create(:quality_user) }
          let(:update_attributes) { { :quality_critical => false } }
          subject { put :update, params: { :id => other_update_movement.id, :movement => update_attributes } }
        end
      end
      
      context "cannot update other attributes of movements for their contracts" do
        it_behaves_like "cannot update this attribute" do
          let(:one_user) { FactoryBot.create(:quality_user) }
          let(:update_attributes) { { :production_critical => true } }
          subject { put :update, params: { :id => update_movement.id, :movement => update_attributes } }
        end
      end
      
      context "cannot update other attributes of movements for other contracts" do
        it_behaves_like "has no ability for this action with catched CanCan::AccessDenied error" do
          let(:one_user) { FactoryBot.create(:quality_user) }
          let(:update_attributes) { { :production_critical => true } }
          subject { put :update, params: { :id => other_update_movement.id, :movement => update_attributes } }
        end
      end
    end
  end
end