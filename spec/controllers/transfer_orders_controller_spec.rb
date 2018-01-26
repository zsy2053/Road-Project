require 'rails_helper'

RSpec.describe TransferOrdersController, type: :controller do
  describe "GET #index" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:transfer_order1) { FactoryBot.create(:transfer_order, :contract_id => contract1.id)}
    let!(:transfer_order2) { FactoryBot.create(:transfer_order, :contract_id => contract2.id)}
    subject { get :index, {} }

    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authorized user with access" do
      before(:each) do
        @api_trackware_user = FactoryBot.create(:api_trackware_user)
        add_jwt_header(request, @api_trackware_user)
      end

      it "returns a success response if login." do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of transfer order." do
        # There should be 2 transfer orders inside the database, and the user can access them.
        subject
        result = assigns(:transfer_orders)
        expect(result.count).to eq(2)
        expect(result).to include(transfer_order1)
        expect(result).to include(transfer_order2)
      end
    end
  end

  describe "GET #show" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:station1) { FactoryBot.create(:station, :name => "station 1") }
    let!(:transfer_order1) { FactoryBot.create(:transfer_order, :contract_id => contract1.id, :station_id => station1.id)}

    context "for anonymous user" do
      it "returns a failed response without login" do
        get :show, params: { :id => transfer_order1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for authorized user" do
      before(:each) do
        @api_trackware_user = FactoryBot.create(:api_trackware_user)
        add_jwt_header(request, @api_trackware_user)
      end

      it "returns a success response if login." do
        get :show, params: { :id => transfer_order1.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create_or_update" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:station1) { FactoryBot.create(:station, :name => "station 1") }
    let!(:to_number) { '12345' }
    let!(:valid_attributes) {
      {
      station_id: station1.id,
      contract_id: contract1.id,
      order: 123,
      delivery_device: 'delivery_device',
      priority: 'first',
      reason_code: 'new reason',
      name: 'new name',
      code: 'new code',
      installation: 'new installation',
      to_number: to_number,
      car: 'car',
      sort_string: 'sort_string',
      date_entered: Date.today,
      date_received_3pl: Date.today,
      date_staging: Date.today,
      date_shipped_bt: Date.today,
      date_received_bt: Date.today,
      date_production: Date.today
      }
    }
    
    subject { post :create_or_update, params: { to_number: to_number, transfer_order: valid_attributes } }
    
    context "for transfer order that does not exist" do
      before(:each) do
        expect(TransferOrder.where(to_number: to_number)).to be_empty
      end
      
      context "for anonymous user" do
        it "returns a failed response without login" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end
      
      context "for authorized user" do
        before(:each) do
          @api_trackware_user = FactoryBot.create(:api_trackware_user)
          add_jwt_header(request, @api_trackware_user)
        end
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "assigns the new transfer order" do
          subject
          result = assigns(:transfer_order)
          expect(result['order']).to eq(123)
          expect(result['delivery_device']).to eq('delivery_device')
          expect(result['priority']).to eq('first')
          expect(result['reason_code']).to eq('new reason')
          expect(result['name']).to eq('new name')
          expect(result['code']).to eq('new code')
          expect(result['installation']).to eq('new installation')
          expect(result['to_number']).to eq('12345')
          expect(result['car']).to eq('car')
          expect(result['sort_string']).to eq('sort_string')
          expect(result['date_entered']).to eq(Date.today)
          expect(result['date_received_3pl']).to eq(Date.today)
          expect(result['date_staging']).to eq(Date.today)
          expect(result['date_shipped_bt']).to eq(Date.today)
          expect(result['date_received_bt']).to eq(Date.today)
          expect(result['date_production']).to eq(Date.today)
        end
        
        it "persists the new transfer order" do
          expect{ subject }.to change{ TransferOrder.count }.by(1)
          
          result = TransferOrder.last
          expect(result['order']).to eq(123)
          expect(result['delivery_device']).to eq('delivery_device')
          expect(result['priority']).to eq('first')
          expect(result['reason_code']).to eq('new reason')
          expect(result['name']).to eq('new name')
          expect(result['code']).to eq('new code')
          expect(result['installation']).to eq('new installation')
          expect(result['to_number']).to eq('12345')
          expect(result['car']).to eq('car')
          expect(result['sort_string']).to eq('sort_string')
          expect(result['date_entered']).to eq(Date.today)
          expect(result['date_received_3pl']).to eq(Date.today)
          expect(result['date_staging']).to eq(Date.today)
          expect(result['date_shipped_bt']).to eq(Date.today)
          expect(result['date_received_bt']).to eq(Date.today)
          expect(result['date_production']).to eq(Date.today)
        end
      end

      context "for authorized user but read only" do
        before(:each) do
          @quality = FactoryBot.create(:quality_user)
          add_jwt_header(request, @quality)
        end
        
        it "returns a forbidden error message." do
          subject
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
    
    context "for transfer order that does exist" do
      let!(:transfer_order1) { FactoryBot.create(:transfer_order, :to_number => to_number, :contract_id => contract1.id, :station_id => station1.id)}
      
      before(:each) do
        expect(TransferOrder.where(to_number: to_number)).to_not be_empty
      end
      
      context "for anonymous user" do
        it "returns a failed response without login" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end
      
      context "for authorized user" do
        before(:each) do
          @api_trackware_user = FactoryBot.create(:api_trackware_user)
          add_jwt_header(request, @api_trackware_user)
        end
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "assigns the updated transfer order" do
          subject
          result = assigns(:transfer_order)
          expect(result['order']).to eq(123)
          expect(result['delivery_device']).to eq('delivery_device')
          expect(result['priority']).to eq('first')
          expect(result['reason_code']).to eq('new reason')
          expect(result['name']).to eq('new name')
          expect(result['code']).to eq('new code')
          expect(result['installation']).to eq('new installation')
          expect(result['to_number']).to eq('12345')
          expect(result['car']).to eq('car')
          expect(result['sort_string']).to eq('sort_string')
          expect(result['date_entered']).to eq(Date.today)
          expect(result['date_received_3pl']).to eq(Date.today)
          expect(result['date_staging']).to eq(Date.today)
          expect(result['date_shipped_bt']).to eq(Date.today)
          expect(result['date_received_bt']).to eq(Date.today)
          expect(result['date_production']).to eq(Date.today)
        end
        
        it "updates the existing transfer order" do
          expect{ subject }.to change{ TransferOrder.count }.by(0)
          
          result = TransferOrder.last
          expect(result['order']).to eq(123)
          expect(result['delivery_device']).to eq('delivery_device')
          expect(result['priority']).to eq('first')
          expect(result['reason_code']).to eq('new reason')
          expect(result['name']).to eq('new name')
          expect(result['code']).to eq('new code')
          expect(result['installation']).to eq('new installation')
          expect(result['to_number']).to eq('12345')
          expect(result['car']).to eq('car')
          expect(result['sort_string']).to eq('sort_string')
          expect(result['date_entered']).to eq(Date.today)
          expect(result['date_received_3pl']).to eq(Date.today)
          expect(result['date_staging']).to eq(Date.today)
          expect(result['date_shipped_bt']).to eq(Date.today)
          expect(result['date_received_bt']).to eq(Date.today)
          expect(result['date_production']).to eq(Date.today)
        end
      end

      context "for authorized user but read only" do
        before(:each) do
          @quality = FactoryBot.create(:quality_user)
          add_jwt_header(request, @quality)
        end
        
        it "returns a forbidden error message." do
          subject
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
