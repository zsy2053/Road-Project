require 'rails_helper'

RSpec.describe RoadOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:road_order)).to be_valid
  end
  
  it { should belong_to(:station) }
  
  it { should belong_to(:contract) }
  
  it { should belong_to(:author) }
  
  it { should validate_presence_of :car_type }
  
  it { should validate_presence_of :work_centre }
    
  it { should validate_presence_of :start_car }
  it { should validate_numericality_of(:start_car).only_integer.is_greater_than(0) }
  
  describe 'start_car offset validation' do
    context "for a new car type" do
      let(:car_type) { "new car type" }
      let(:station) { FactoryBot.create(:station) }
      
      before(:each) do
        expect(RoadOrder.where(:car_type => car_type)).to be_empty
      end
      
      it "should accept a value of 1" do
        expect(FactoryBot.build(:road_order, station: station, car_type: car_type, start_car: 1)).to be_valid
      end
      
      it "should reject a value that is not 1" do
        expect(FactoryBot.build(:road_order, station: station, car_type: car_type, start_car: 2)).to_not be_valid
      end
    end
    
    context "for an existing car type" do
      let(:car_type) { 'the car type' }
      let!(:old_road_order) { FactoryBot.create(:road_order, car_type: car_type, start_car: 1) }
      
      context "where cars exist" do
        let(:max_car) { 5 }
        before(:each) do
          # can't rely on sequence, because it doesn't start at 1 every time
          cars = [
            FactoryBot.create(:car, contract: old_road_order.contract, car_type: car_type, number: 1),
            FactoryBot.create(:car, contract: old_road_order.contract, car_type: car_type, number: 2),
            FactoryBot.create(:car, contract: old_road_order.contract, car_type: car_type, number: 3),
            FactoryBot.create(:car, contract: old_road_order.contract, car_type: car_type, number: 4),
            FactoryBot.create(:car, contract: old_road_order.contract, car_type: car_type, number: 5)
          ]
          cars.each do |car|
            FactoryBot.create(:car_road_order, road_order: old_road_order, car: car)
          end
        end
        
        describe "at the same station" do
          it "should reject if less than" do
            new_start_car = max_car + old_road_order.contract.minimum_offset - 1
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to_not be_valid
          end
          
          it "should accept if equal to" do
            new_start_car = max_car + old_road_order.contract.minimum_offset
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to be_valid
          end
          
          it "should accept if greater than" do
            new_start_car = max_car + old_road_order.contract.minimum_offset + 1
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to be_valid
          end
        end
        
        describe "at a different station" do
          let!(:other_station) { FactoryBot.create(:station, contract: old_road_order.contract) }
          
          before(:each) do
            expect(other_station).to_not eq(old_road_order.station)
            expect(other_station.contract).to eq(old_road_order.contract)
            expect(other_station.contract.site).to eq(old_road_order.contract.site)
            expect(RoadOrder.where(:station_id => other_station.id)).to be_empty
          end
          
          it "should accept the same start car value" do
            new_road_order = FactoryBot.build(:road_order,
            station: other_station,
            car_type: old_road_order.car_type,
            start_car: old_road_order.start_car)
            
            expect(new_road_order).to be_valid
          end
        end
      end
      
      context "where no cars exist" do
        before(:each) do
          # expect no cars to exist that reference this road order
          expect(Car.all).to be_empty
        end
        
        describe "at the same station" do
          it "should reject if less than" do
            extra_road_order = FactoryBot.create(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: 10)
            
            new_start_car = extra_road_order.start_car - 1
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to_not be_valid
          end
          
          it "should reject if equal to" do
            new_start_car = old_road_order.start_car
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to_not be_valid
          end
          
          it "should accept if greater than" do
            new_start_car = old_road_order.start_car + 1
            new_road_order = FactoryBot.build(:road_order,
              station: old_road_order.station,
              car_type: old_road_order.car_type,
              start_car: new_start_car)
            
            expect(new_road_order).to be_valid
          end
        end
        
        describe "at a different station" do
          let!(:other_station) { FactoryBot.create(:station, contract: old_road_order.contract) }
          
          before(:each) do
            expect(other_station).to_not eq(old_road_order.station)
            expect(other_station.contract).to eq(old_road_order.contract)
            expect(other_station.contract.site).to eq(old_road_order.contract.site)
            expect(RoadOrder.where(:station_id => other_station.id)).to be_empty
          end
          
          it "should accept the same start car value" do
            new_road_order = FactoryBot.build(:road_order,
            station: other_station,
            car_type: old_road_order.car_type,
            start_car: old_road_order.start_car)
            
            expect(new_road_order).to be_valid
          end
        end
      end
    end
  end
  
  it { should have_many(:definitions).dependent(:destroy) }
  
  # Rails 5 prevents the following from being used
  #it { should serialize :positions }
  describe :positions do
    it "should serialize an array" do
      arr = [ "A1", "B1" ]
      x = FactoryBot.create(:road_order, positions: arr)
      x.reload
      expect(x.positions).to eq(arr)
    end
  end
  
  # Rails 5 prevents the following from being used
  #it { should serialize :day_shifts }
  describe :day_shifts do
    it "should serialize a has" do
      hsh = {
        "1" => [
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ],
        "2" =>[
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ]
      }
      x = FactoryBot.create(:road_order, day_shifts: hsh)
      x.reload
      expect(x.day_shifts).to eq(hsh)
    end
  end
end