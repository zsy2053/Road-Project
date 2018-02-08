require 'rails_helper'

RSpec.describe CarRoadOrdersController, type: :controller do
  
  describe "GET #index" do
    let!(:contract) { FactoryBot.create(:contract) }
    
    let!(:station1) { FactoryBot.create(:station, contract: contract) }
    let!(:station2) { FactoryBot.create(:station, contract: contract) }
    
    let!(:road_order1) { FactoryBot.create(:road_order, contract: contract, station: station1, start_car: 1, positions: [ "A1", "B1", "C1"]) }
    let!(:road_order2) { FactoryBot.create(:road_order, contract: contract, station: station2, start_car: 1, positions: [ "A1", "B1", "C1"]) }
    
    let!(:car1) { FactoryBot.create(:car, contract: contract, number: 1) }
    let!(:car2) { FactoryBot.create(:car, contract: contract, number: 2) }
    
    let!(:car_road_order11) { FactoryBot.create(:car_road_order, car: car1, road_order: road_order1) }
    let!(:car_road_order12) { FactoryBot.create(:car_road_order, car: car1, road_order: road_order2) }
    let!(:car_road_order21) { FactoryBot.create(:car_road_order, car: car2, road_order: road_order1) }
    let!(:car_road_order22) { FactoryBot.create(:car_road_order, car: car2, road_order: road_order2) }
    
    let!(:other_contract) { FactoryBot.create(:contract, site: contract.site) }
    let!(:other_station) { FactoryBot.create(:station, contract: other_contract) }
    let!(:other_road_order) { FactoryBot.create(:road_order, contract: other_contract, station: other_station, start_car: 1) }
    let!(:other_car) { FactoryBot.create(:car, contract: other_contract, number: 1) }
    let!(:other_car_road_order) { FactoryBot.create(:car_road_order, car: other_car, road_order: other_road_order) }
    
    context "without additional params" do
      subject { get :index, {} }
      
      context "for anonymous user" do
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end
      
      context "for a supervisor" do
        before(:each) do
          @user = FactoryBot.create(:supervisor_user)
          FactoryBot.create(:access, contract_id: contract.id, user_id: @user.id)
          add_jwt_header(request, @user)
        end
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "assigns all car road orders the user has access to" do
          subject
          result = assigns(:car_road_orders)
          expect(result.count).to eq(4)
          
          expect(result).to include(car_road_order11)
          expect(result).to include(car_road_order12)
          expect(result).to include(car_road_order21)
          expect(result).to include(car_road_order22)
          
          expect(result).to_not include(other_car_road_order)
        end
      end
    end
    
    context "with additional params" do
      subject { get :index, params: { :road_order_id => car_road_order21.road_order.id, :car_number => car_road_order21.car.number } }
      
      context "for anonymous user" do
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end
      
      context "for a supervisor" do
        before(:each) do
          @user = FactoryBot.create(:supervisor_user)
          FactoryBot.create(:access, contract_id: contract.id, user_id: @user.id)
          add_jwt_header(request, @user)
        end
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "assigns all car road orders" do
          subject
          result = assigns(:car_road_orders)
          expect(result.count).to eq(1)
          expect(result).to include(car_road_order21)
        end
      end
    end
  end
  
  describe "POST #create" do
    let!(:road_order) { FactoryBot.create(:road_order, start_car: 1, positions: [ "A1", "B1", "C1"]) }

    let!(:definitions) { FactoryBot.create_list(:definition, 10, road_order: road_order) }
    
    let(:station) { road_order.station }
    let(:contract) { road_order.contract }
    
    let!(:car) { FactoryBot.create(:car, :contract_id => contract.id, :car_type => road_order.car_type, :number => road_order.start_car) }
    
    subject { post :create, params: { car_road_order: { :road_order_id => road_order.id, :car_number => car_number } } }
    
    context "anonymous user" do
      describe "for an existing car" do
        let(:car_number) { car.number }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
      
      describe "for a new car" do
        let(:car_number) { car.number + 1 }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
    end
    
    context "unauthorized user" do
      before(:each) do
        @user = FactoryBot.create(:admin_user)
        FactoryBot.create(:access, contract_id: contract.id, user_id: @user.id)
        add_jwt_header(request, @user)
      end
      
      describe "for an existing car" do
        let(:car_number) { car.number }
      
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
      
      describe "for a new car" do
        let(:car_number) { car.number + 1 }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
    end
    
    context "supervisor without access" do
      before(:each) do
        @user = FactoryBot.create(:supervisor_user)
        add_jwt_header(request, @user)
      end
      
      describe "for an existing car" do
        let(:car_number) { car.number }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
      
      describe "for a new car" do
        let(:car_number) { car.number + 1 }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
      end
    end
    
    context "supervisor with access" do
      before(:each) do
        @user = FactoryBot.create(:supervisor_user)
        FactoryBot.create(:access, contract_id: contract.id, user_id: @user.id)
        add_jwt_header(request, @user)
      end
      
      describe "for an existing car/road order pair" do
        let(:car_number) { car.number }
        let!(:car_road_order) { FactoryBot.create(:car_road_order, road_order: road_order, car: car) }
        
        it "returns a failed response" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({ "road_order_id" => [ "has already been taken" ] })
        end
        
        it "doesn't create any objects" do
          expect{ subject }.to change{ Car.count + CarRoadOrder.count + Movement.count + Position.count }.by(0)
        end
        
      end
      
      describe "for an existing car" do
        let(:car_number) { car.number }
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "doesn't create a car record" do
          expect{ subject }.to change{ Car.count }.by(0)
        end
        
        it "creates a car road order" do
          expect{ subject }.to change{ CarRoadOrder.count }.by(1)
        end
        
        it "creates associated movements" do
          expect{ subject }.to change{ Movement.count }.by(10)
        end
        
        it "creates associated positions" do
          expect{ subject }.to change{ Position.count }.by(4)
          
          expect(road_order.positions).to eq([ "A1", "B1", "C1" ])
          
          cro = CarRoadOrder.last
          expect(Position.where(car_road_order: cro, name: "A1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "B1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "C1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "SNAGS", allows_multiple: true).count).to eq(1)
        end
      end
      
      describe "for a new car" do
        let(:car_number) { car.number + 1 }
        
        it "returns a success response" do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it "doesn't create a car record" do
          expect{ subject }.to change{ Car.count }.by(1)
        end
        
        it "creates a car road order" do
          expect{ subject }.to change{ CarRoadOrder.count }.by(1)
        end
        
        it "creates associated movements" do
          expect{ subject }.to change{ Movement.count }.by(10)
        end
        
        it "creates associated positions" do
          expect{ subject }.to change{ Position.count }.by(4)
          
          expect(road_order.positions).to eq([ "A1", "B1", "C1" ])
          
          cro = CarRoadOrder.last
          expect(Position.where(car_road_order: cro, name: "A1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "B1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "C1", allows_multiple: false).count).to eq(1)
          expect(Position.where(car_road_order: cro, name: "SNAGS", allows_multiple: true).count).to eq(1)
        end
      end
    end
  end
end
