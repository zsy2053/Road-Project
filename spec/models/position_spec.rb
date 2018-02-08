require 'rails_helper'

RSpec.describe Position, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:position)).to be_valid
  end
  
  it { should belong_to(:car_road_order) }
  
  it { should validate_presence_of :name }
  
  it "should reject duplicate names for the same car road order" do
    car_road_order = FactoryBot.create(:car_road_order)
    
    name = "A1"
    position1 = FactoryBot.create(:position, car_road_order: car_road_order, name: name)
    position2 = FactoryBot.build(:position, car_road_order: car_road_order, name: name)
    
    expect(position2).to_not be_valid
  end
  
  it "should allow distinct names for the same car road order" do
    car_road_order = FactoryBot.create(:car_road_order)
    
    position1 = FactoryBot.create(:position, car_road_order: car_road_order, name: "A1")
    position2 = FactoryBot.build(:position, car_road_order: car_road_order, name: "A2")
    
    expect(position2).to be_valid
  end
  
  it "should allow duplicate names for different car road orders" do
    car_road_order1 = FactoryBot.create(:car_road_order)
    car_road_order2 = FactoryBot.create(:car_road_order, road_order: car_road_order1.road_order)
    
    name = "A1"
    position1 = FactoryBot.create(:position, car_road_order: car_road_order1, name: name)
    position2 = FactoryBot.build(:position, car_road_order: car_road_order2, name: name)
    
    expect(position2).to be_valid
  end
  
  it "should allow different names for different car road orders" do
    car_road_order1 = FactoryBot.create(:car_road_order)
    car_road_order2 = FactoryBot.create(:car_road_order, road_order: car_road_order1.road_order)
    
    position1 = FactoryBot.create(:position, car_road_order: car_road_order1, name: "A1")
    position2 = FactoryBot.build(:position, car_road_order: car_road_order2, name: "A2")
    
    expect(position2).to be_valid
  end
end
