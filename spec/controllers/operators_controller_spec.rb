require 'rails_helper'

RSpec.describe OperatorsController, type: :controller do
  let(:site) { FactoryBot.create(:site) }
  describe "GET #index" do
    let!(:operator1) { FactoryBot.create(:operator, :site => site, :badge => "operator1") }
    let!(:operator2) { FactoryBot.create(:operator, :site => site, :badge => "operator2") }

    subject { get :index, {} }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticated user with access" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, :site => site)
        add_jwt_header(request, @super_admin)
      end

      it "returns a success response" do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of operators" do
        subject
        result = assigns(:operators)
        expect(result.count).to eq(2)
        expect(result).to include(operator1)
        expect(result).to include(operator2)
      end
      
      context "filtering by time" do
        let!(:operator3) { FactoryBot.create(:operator, :site => site, :badge => "operator3", :created_at => 1.hour.ago, :updated_at => 1.hour.ago) }
        let!(:operator4) { FactoryBot.create(:operator, :site => site, :badge => "operator4", :created_at => 1.hour.ago, :updated_at => 1.hour.ago) }
        
        it "with a valid time works" do
          # use close to current time
          now_as_timestamp = 1.minute.ago.to_f * 1000
          
          get :index, params: { :time => now_as_timestamp }
          result = assigns(:operators)
          expect(result.count).to eq(2)
          expect(result).not_to include(operator4)
          expect(result).not_to include(operator3)
          expect(result).to include(operator2)
          expect(result).to include(operator1)
        end
        
        it "with an invalid time returns all" do
          # record current time
          not_a_timestamp = "apple"
          
          get :index, params: { :time => not_a_timestamp }
          result = assigns(:operators)
          expect(result.count).to eq(4)
          expect(result).to include(operator4)
          expect(result).to include(operator3)
          expect(result).to include(operator2)
          expect(result).to include(operator1)
        end
      end
    end

    context "for authenticate user without access" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        add_jwt_header(request, @method_engineer)
      end

      it "returns a forbidden response" do
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #show" do
    let!(:operator1) { FactoryBot.create(:operator, :site => site) }

    context "for anonymous user" do
      it "returns a failed response without login" do
        get :show, params: { :id => operator1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticate user with access" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, :site => site)
        add_jwt_header(request, @super_admin)
      end

      it "returns a success response" do
        get :show, params: { :id => operator1.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "for authenticate user without access" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        add_jwt_header(request, @method_engineer)
      end

      it "returns a forbidden response" do
        get :show, params: { :id => operator1.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH #update" do
    let!(:operator1) { FactoryBot.create(:operator, :site => site) }
    let!(:operator2) { FactoryBot.create(:operator, :site => site) }
    let!(:attributes) {
      {
        id: operator1.id,
        first_name: "test1",
        last_name: "test2",
        employee_number: "tesnt12345",
        badge: "test215235",
        suspended: true,
        site_id: site.id
      }
    }
    context "for anonymous user" do
      it "returns unauthorized" do
        patch :update, params: { :id => operator1, :operator => attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticated user with access" do
      before(:each) do
        @supervisor = FactoryBot.create(:supervisor_user, :site => site)
        add_jwt_header(request, @supervisor)
      end

      it("update the operator with attributes") do
        patch :update, params: { :id => operator1.id, :operator => attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context "for authenticated user without access" do
      before(:each) do
        @method_engineer_user = FactoryBot.create(:method_engineer_user, :site => site)
        add_jwt_header(request, @method_engineer_user)
      end

      it "is forbidden" do
        patch :update, params: { :id => operator1.id, :operator => attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  describe "POST #create" do
    let!(:valid_attributes) {
      {
        first_name: "test1",
        last_name: "test2",
        employee_number: "tesnt12345",
        badge: "test215235",
        suspended: true,
        site_id: site.id
      }
    }

    let(:invalid_attributes) {
      {
        apple: "banana"
      }
    }

    context "for anonymous user" do
      it "returns unauthorized" do
        post :create, params: { operator: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticated user" do
      describe "with access" do
        before(:each) do
          @super_admin = FactoryBot.create(:super_admin_user, :site => site)
          add_jwt_header(request, @super_admin)
        end

        it "succeeds" do
          post :create, params: { operator: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:success)
        end

        it "creates a new record" do
          expect{ post :create, params: { operator: valid_attributes } }.to change{ Operator.count }.by(1)

          result = Operator.last
          expect(response.location).to eq(operator_url(result))
          expect(result.first_name).to eq('test1')
          expect(result.last_name).to eq('test2')
          expect(result.employee_number).to eq('tesnt12345')
          expect(result.badge).to eq("test215235")
          expect(result.suspended).to eq(true)
        end

        it "rejects invalid input" do
          post :create, params: { operator: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      describe "without access" do
        before(:each) do
          @station_user = FactoryBot.create(:station_user, :site => site)
          add_jwt_header(request, @station_user)
        end

        it "is forbidden" do
          post :create, params: { operator: valid_attributes }
          expect(response).to have_http_status(:forbidden)
        end

        it "does not create a new record" do
          expect{ post :create, params: { operator: valid_attributes } }.to change{ Operator.count }.by(0)
        end
      end
    end
  end

  describe "GET #showbadge" do
    let!(:operator1) { FactoryBot.create(:operator, :site => site, :badge => "operator1") }
    context "for anonymous user" do
      it "returns unauthorized" do
        get :showbadge, params: { :badge => operator1.badge }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authenticated user with access" do
      before(:each) do
        @super_admin = FactoryBot.create(:super_admin_user, :site => site)
        add_jwt_header(request, @super_admin)
      end

      it("get the operator with badge id") do
        get :showbadge, params: { :badge => operator1.badge }
        expect(response).to have_http_status(:success)
      end

      it "rejects invalid parameter" do
        get :showbadge, params: { :badge => "not_id" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "for authenticated user but have no access" do
      before(:each) do
        @method_engineer = FactoryBot.create(:method_engineer_user, :site => site)
        add_jwt_header(request, @method_engineer)
      end

      it "is forbidden" do
        get :showbadge, params: { :badge => operator1.badge }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
