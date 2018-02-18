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
  
  describe :operators do
    let!(:car_road_order) { FactoryBot.create(:car_road_order) }
    let!(:site) { car_road_order.road_order.station.contract.site }
    
    context "for a position that allows multiple" do
      let(:allows_multiple) { true }
      
      it "can be empty" do
        operators = []
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to be_valid
      end
      
      it "can have one operator" do
        operators = FactoryBot.create_list(:operator, 1, site: site)
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to be_valid
      end
      
      it "can have more than one operator" do
        operators = FactoryBot.create_list(:operator, 2, site: site)
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to be_valid
      end
    end
    
    context "for a position that does not allow multiple" do
      let(:allows_multiple) { false }
      
      it "can be empty" do
        operators = []
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to be_valid
      end
      
      it "can have one operator" do
        operators = FactoryBot.create_list(:operator, 1, site: site)
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to be_valid
      end
      
      it "cannot have more than one operator" do
        operators = FactoryBot.create_list(:operator, 2, site: site)
        position = FactoryBot.build(:position, car_road_order: car_road_order, allows_multiple: allows_multiple, operators: operators)
        expect(position).to_not be_valid
      end
    end
  end
end
