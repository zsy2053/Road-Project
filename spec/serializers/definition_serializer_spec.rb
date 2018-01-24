require 'rails_helper'

RSpec.describe DefinitionSerializer, type: :serializer do
  let(:serializer) { described_class.new(definition) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  
  let(:subject) { JSON.parse(serialization.to_json) }
  
  context "definition with one position" do
    let(:road_order) { FactoryBot.create(:road_order) }
    let(:definition) { FactoryBot.build_stubbed(:definition,
      id: 1231,
      road_order: road_order,
      name: "Task 111",
      description: "Task Description",
      work_location: "Location",
      day: 3,
      shift: 4,
      expected_duration: 90,
      breaks: 15,
      expected_start: "08:00:00",
      expected_end: "09:45:00",
      serialized: false,
      positions: [ 'A1' ])
    }
    
    it "only contains the expected keys" do
      expect(subject.keys).to contain_exactly(
        'id',
        'road_order_id',
        'name',
        'description',
        'work_location',
        'day',
        'shift',
        'expected_duration',
        'breaks',
        'expected_start',
        'expected_end',
        'serialized',
        'positions'
      )
    end
    
    it "returns expected id" do
      expect(subject['id']).to eq(1231)
    end
    
    it "returns expected road_order" do
      expect(subject['road_order_id']).to eq(road_order.id)
    end
    
    it "returns expected name" do
      expect(subject['name']).to eq('Task 111')
    end
    
    it "returns expected description" do
      expect(subject['description']).to eq('Task Description')
    end
    
    it "returns expected work_location" do
      expect(subject['work_location']).to eq('Location')
    end
    
    it "returns expected day" do
      expect(subject['day']).to eq('3')
    end
    
    it "returns expected shift" do
      expect(subject['shift']).to eq('4')
    end
    
    it "returns expected expected_duration" do
      expect(subject['expected_duration']).to eq(90)
    end
    
    it "returns expected breaks" do
      expect(subject['breaks']).to eq(15)
    end
    
    it "returns expected expected_start" do
      expect(subject['expected_start']).to eq('08:00:00')
    end
    
    it "returns expected expected_end" do
      expect(subject['expected_end']).to eq('09:45:00')
    end
    
    it "returns expected serialized" do
      expect(subject['serialized']).to eq(false)
    end
    
    it "returns expected positions" do
      expect(subject['positions']).to eq([ 'A1' ])
    end
  end
  
  context "definition with two positions" do
    let(:road_order) { FactoryBot.create(:road_order) }
    let(:definition) { FactoryBot.build_stubbed(:definition,
      id: 1231,
      road_order: road_order,
      name: "Task 111",
      description: "Task Description",
      work_location: "Location",
      day: 3,
      shift: 4,
      expected_duration: 90,
      breaks: 15,
      expected_start: "08:00:00",
      expected_end: "09:45:00",
      serialized: false,
      positions: [ 'C1', 'D1' ])
    }
    
    it "only contains the expected keys" do
      expect(subject.keys).to contain_exactly(
        'id',
        'road_order_id',
        'name',
        'description',
        'work_location',
        'day',
        'shift',
        'expected_duration',
        'breaks',
        'expected_start',
        'expected_end',
        'serialized',
        'positions'
      )
    end
    
    it "returns expected id" do
      expect(subject['id']).to eq(1231)
    end
    
    it "returns expected road_order" do
      expect(subject['road_order_id']).to eq(road_order.id)
    end
    
    it "returns expected name" do
      expect(subject['name']).to eq('Task 111')
    end
    
    it "returns expected description" do
      expect(subject['description']).to eq('Task Description')
    end
    
    it "returns expected work_location" do
      expect(subject['work_location']).to eq('Location')
    end
    
    it "returns expected day" do
      expect(subject['day']).to eq('3')
    end
    
    it "returns expected shift" do
      expect(subject['shift']).to eq('4')
    end
    
    it "returns expected expected_duration" do
      expect(subject['expected_duration']).to eq(90)
    end
    
    it "returns expected breaks" do
      expect(subject['breaks']).to eq(15)
    end
    
    it "returns expected expected_start" do
      expect(subject['expected_start']).to eq('08:00:00')
    end
    
    it "returns expected expected_end" do
      expect(subject['expected_end']).to eq('09:45:00')
    end
    
    it "returns expected serialized" do
      expect(subject['serialized']).to eq(false)
    end
    
    it "returns expected positions" do
      expect(subject['positions']).to eq([ 'C1', 'D1' ])
    end
  end
end
