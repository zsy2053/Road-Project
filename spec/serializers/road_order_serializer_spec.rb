require 'rails_helper'

RSpec.describe RoadOrderSerializer, type: :serializer do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:serializer) { described_class.new(road_order) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  
  before(:each) do
    road_order.reload
  end
  
  let(:subject) { JSON.parse(serialization.to_json) }
    
  let(:id) { road_order.id }
  
  # ensure S3 gets cleaned up
  after(:each) do
    RoadOrder.destroy_all
  end
  
  context "road order with two definitions" do
    let!(:contract) { FactoryBot.create(:contract, name: "Contract Name") }
    let!(:station) { FactoryBot.create(:station, contract: contract, name: "Station Name") }
    let!(:road_order) { FactoryBot.create(:road_order,
      contract: contract,
      station: station,
      car_type: "COACH",
      start_car: 1,
      work_centre: "Work Centre",
      module: "Module",
      day_shifts: {
        "1" => [
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ],
        "2" =>[
          { :shift => "1", :start => "07:00:00", :end => "13:00:00" },
          { :shift => "1", :start => "13:00:00", :end => "19:00:00" }
        ]
      },
      positions: [ 'A1', 'B1'],
      # import is not being defined to save calls against S3 since 'import_url' attribute is not serialized
    ) }
    let!(:definition1) { FactoryBot.create(:definition,
      id: 1231,
      road_order: road_order,
      name: "Task 111",
      description: "Task Description 1",
      work_location: "Location 1",
      day: 1,
      shift: 2,
      expected_duration: 90,
      breaks: 15,
      expected_start: "08:00:00",
      expected_end: "09:45:00",
      serialized: false,
      positions: [ 'A1' ])
    }
    let!(:definition2) { FactoryBot.create(:definition,
      id: 1232,
      road_order: road_order,
      name: "Task 112",
      description: "Task Description 2",
      work_location: "Location 2",
      day: 3,
      shift: 4,
      expected_duration: 90,
      breaks: 15,
      expected_start: "09:45:00",
      expected_end: "11:30:00",
      serialized: false,
      positions: [ 'A1' ])
    }
    
    it "only contains the expected keys" do
      expect(subject.keys).to contain_exactly(
        'id',
        'car_type',
        'start_car',
        'work_centre',
        'module',
        'station',
        'station_name',
        'contract',
        'contract_name',
        'day_shifts',
        'max_car'
      )
    end
    
    it "has expected id" do
      expect(subject['id']).to eq(id)
    end
    
    it "has expected car_type" do
      expect(subject['car_type']).to eq('COACH')
    end
    
    it "has expected start_car" do
      expect(subject['start_car']).to eq(1)
    end
    
    it "has expected work_centre" do
      expect(subject['work_centre']).to eq('Work Centre')
    end
    
    it "has expected module" do
      expect(subject['module']).to eq('Module')
    end
    
    it "has expected station" do
      expect(subject['station_name']).to eq("Station Name")
    end
    
    it "has expect contract" do
      expect(subject['contract_name']).to eq("Contract Name")
    end
    
    describe "with no cars associated" do
      before(:each) do
        expect(CarRoadOrder.where(road_order_id: road_order.id).count).to eq(0)
      end
      
      it "has a max_car of 0" do
        expect(subject['max_car']).to eq(0)
      end
    end
    
    describe "with two cars associated" do
      let!(:car1) { FactoryBot.create(:car, car_type: road_order.car_type, number: 1) }
      let!(:car2) { FactoryBot.create(:car, car_type: road_order.car_type, number: 2) }
      
      let!(:car_road_order1) { FactoryBot.create(:car_road_order, car: car1, road_order: road_order) }
      let!(:car_road_order2) { FactoryBot.create(:car_road_order, car: car2, road_order: road_order) }
      
      before(:each) do
        expect(CarRoadOrder.where(road_order_id: road_order.id).count).to eq(2)
      end
      
      it "has a max_car of 2" do
        expect(subject['max_car']).to eq(2)
      end
    end
  end
end
