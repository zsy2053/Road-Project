require 'rails_helper'

RSpec.describe CarRoadOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:car_road_order)).to be_valid
  end
  
  it { should belong_to(:car) }
  
  it { should belong_to(:road_order) }
  
  it "should reject duplicate records for the same car and road order pair" do
    contract = FactoryBot.create(:contract)
    station = FactoryBot.create(:station, contract: contract)
    road_order = FactoryBot.create(:road_order, contract: contract, station: station, start_car: 1)
    car = FactoryBot.create(:car, contract: contract, car_type: road_order.car_type, number: 1)
    
    cro1 = FactoryBot.create(:car_road_order, car: car, road_order: road_order)
    
    cro2 = FactoryBot.build(:car_road_order, car: car, road_order: road_order)
    
    expect(cro2).to_not be_valid
    expect(cro2.errors.messages[:road_order_id]).to eq(['has already been taken'])
  end
  
  it "should allow records for the same car and different road orders" do
    contract = FactoryBot.create(:contract)
    
    station1 = FactoryBot.create(:station, contract: contract)
    road_order1 = FactoryBot.create(:road_order, contract: contract, station: station1, start_car: 1)
    
    station2 = FactoryBot.create(:station, contract: contract)
    road_order2 = FactoryBot.create(:road_order, contract: contract, station: station2, car_type: road_order1.car_type, start_car: 1)
    
    expect(road_order1.car_type).to eq(road_order2.car_type)
    
    car = FactoryBot.create(:car, contract: contract, car_type: road_order1.car_type, number: 1)
    
    cro1 = FactoryBot.create(:car_road_order, car: car, road_order: road_order1)
    
    cro2 = FactoryBot.build(:car_road_order, car: car, road_order: road_order2)
    
    expect(cro2).to be_valid
  end
  
  it "should allow records for different cars and same road order" do
    contract = FactoryBot.create(:contract)
    station = FactoryBot.create(:station, contract: contract)
    road_order = FactoryBot.create(:road_order, contract: contract, station: station, start_car: 1)
    
    car1 = FactoryBot.create(:car, contract: contract, car_type: road_order.car_type, number: 1)
    car2 = FactoryBot.create(:car, contract: contract, car_type: road_order.car_type, number: 2)
    
    cro1 = FactoryBot.create(:car_road_order, car: car1, road_order: road_order)
    
    cro2 = FactoryBot.build(:car_road_order, car: car2, road_order: road_order)
    
    expect(cro2).to be_valid
  end
  
  it "should allow records for different cars and different road orders" do
    contract = FactoryBot.create(:contract)
    
    station1 = FactoryBot.create(:station, contract: contract)
    road_order1 = FactoryBot.create(:road_order, contract: contract, station: station1, start_car: 1)
    
    station2 = FactoryBot.create(:station, contract: contract)
    road_order2 = FactoryBot.create(:road_order, contract: contract, station: station2, car_type: road_order1.car_type, start_car: 1)
    
    car1 = FactoryBot.create(:car, contract: contract, car_type: road_order1.car_type, number: 1)
    car2 = FactoryBot.create(:car, contract: contract, car_type: road_order2.car_type, number: 2)
    
    cro1 = FactoryBot.create(:car_road_order, car: car1, road_order: road_order1)
    
    cro2 = FactoryBot.build(:car_road_order, car: car2, road_order: road_order2)
    
    expect(cro2).to be_valid
  end
end
