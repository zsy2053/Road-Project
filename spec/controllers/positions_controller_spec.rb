require 'rails_helper'

RSpec.describe PositionsController, type: :controller do
  let!(:car_road_order1) { FactoryBot.create(:car_road_order) }
  let(:road_order1) { car_road_order1.road_order }
  let(:contract1) { road_order1.contract }
  let(:site) { contract1.site }

  describe "GET #show" do
    let!(:position1) { FactoryBot.create(:position, :car_road_order => car_road_order1) }
    let!(:operator1) { FactoryBot.create(:operator, :site => site, :position => position1) }

    context "for anonymous user" do
      it "returns a failed response without login" do
        get :show, params: { :id => position1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticate user with access" do
      before(:each) do
        @authenticated_user = FactoryBot.create(:supervisor_user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @authenticated_user.id)
        add_jwt_header(request, @authenticated_user)
      end

      it "returns a success response" do
        get :show, params: { :id => position1.id }
        expect(response).to have_http_status(:success)
      end
      
      it "assigns correct object" do
        get :show, params: { :id => position1.id }
        result = assigns(:position)
        expect(result).to eq(position1)
        expect(result.operators.count).to eq(1)
        expect(result.operators).to include(operator1)
      end
    end
    
    context "for authenticate user without access" do
      before(:each) do
        @authenticated_user = FactoryBot.create(:supervisor_user)
        # not assigned any contracts
        add_jwt_header(request, @authenticated_user)
      end

      it "returns a forbidden response" do
        get :show, params: { :id => position1.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
    context "for a position that allows multiple" do
      let!(:position1) { FactoryBot.create(:position, :car_road_order_id => car_road_order1.id, :allows_multiple => true) }
    
      context "when positions are empty" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id) }
        let!(:operator2) { FactoryBot.create(:operator, :site_id => site.id) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [operator1.id, operator2.id] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns a success response" do
            subject
            expect(response).to have_http_status(:success)
          end
    
          it "assigns the updated position" do
            subject
            result = assigns(:position)
            expect(result).to eq(position1)
            expect(result.operators.count).to eq(2)
            expect(result.operators).to include(operator1)
            expect(result.operators).to include(operator2)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
  
      context "when positions are modified" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id, :position => position1) }
        let!(:operator2) { FactoryBot.create(:operator, :site_id => site.id) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [operator2.id] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns a success response" do
            subject
            expect(response).to have_http_status(:success)
          end
    
          it "assigns the updated position" do
            subject
            result = assigns(:position)
            expect(result).to eq(position1)
            expect(result.operators.count).to eq(1)
            expect(result.operators).not_to include(operator1)
            expect(result.operators).to include(operator2)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
  
      context "when positions are removed" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id, :position => position1) }
        let!(:operator2) { FactoryBot.create(:operator, :site_id => site.id, :position => position1) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns a success response" do
            subject
            expect(response).to have_http_status(:success)
          end
    
          it "assigns the updated position" do
            subject
            result = assigns(:position)
            expect(result).to eq(position1)
            expect(result.operators.count).to eq(0)
            expect(result.operators).not_to include(operator1)
            expect(result.operators).not_to include(operator2)
          end
        end
      end
    end
    
    context "for a position that doesn't allow multiple" do
      let!(:position1) { FactoryBot.create(:position, :car_road_order_id => car_road_order1.id, :allows_multiple => false) }
      
      context "when attempting to add multiple operators" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id) }
        let!(:operator2) { FactoryBot.create(:operator, :site_id => site.id) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [operator1.id, operator2.id] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns an unprocessable response" do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
      
      context "when positions are empty" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [operator1] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns a success response" do
            subject
            expect(response).to have_http_status(:success)
          end
    
          it "assigns the updated position" do
            subject
            result = assigns(:position)
            expect(result).to eq(position1)
            expect(result.operators.count).to eq(1)
            expect(result.operators).to include(operator1)
          end
        end
      end
  
      context "when positions are filled" do
        let!(:operator1) { FactoryBot.create(:operator, :site_id => site.id, :position => position1) }
    
        subject { put :update, params: { :id => position1.id, :operator_ids => [] } }
    
        context "for anonymous user" do
          it "returns a failed response without login" do
            subject
            expect(response).to have_http_status(:unauthorized)
          end
        end
    
        context "for authenticate user but no access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:method_engineer_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
          it "returns a failed response" do
            subject
            expect(response).to have_http_status(:forbidden)
          end
        end
    
        context "for authenticate user with access" do
          before(:each) do
            @authenticated_user = FactoryBot.create(:supervisor_user, site: site)
            FactoryBot.create(:access, :contract => contract1, :user_id => @authenticated_user.id)
            add_jwt_header(request, @authenticated_user)
          end
    
          it "returns a success response" do
            subject
            expect(response).to have_http_status(:success)
          end
    
          it "assigns the updated position" do
            subject
            result = assigns(:position)
            expect(result).to eq(position1)
            expect(result.operators.count).to eq(0)
            expect(result.operators).not_to include(operator1)
          end
        end
      end
    end
  end
end
