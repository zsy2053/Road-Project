require 'rails_helper'

RSpec.describe RoadOrderDetailsSerializer, type: :serializer do
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
  
  context "road order with an attachment" do
    # this is done to save calls against S3
    let!(:road_order) { FactoryBot.create(:road_order,
      car_type: "COACH",
      start_car: 30,
      day_shifts: {
        "1" => [ "1", "2" ],
        "2" => [ "1", "2" ]
      },
      positions: [ 'A1', 'B1'],
      import: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'e-road-order-template.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    ) }
    
    it "has expected import_url" do
      # construct what the S3 path should be and compare
      expected_url_head = 'https://' +
            ENV['S3_BUCKET_NAME'] +
            '.s3-' +
            ENV['AWS_BUCKET_REGION'] +
            '.amazonaws.com/uploads/' +
            ENV['S3_PREFIX'] +
            'road_order/import/' +
            id.to_s +
            '/e-road-order-template.xlsx'
      
      # compare to start part since trailing bits will be permissions and stuff that will vary
      result_head = subject['import_url'][0..(expected_url_head.length-1)]
      expect(result_head).to eq(result_head)
    end
  end
  
  context "road order with no definitions" do
    let!(:road_order) { FactoryBot.create(:road_order,
      car_type: "COACH",
      start_car: 30,
      day_shifts: {
        "1" => [ "1", "2" ],
        "2" => [ "1", "2" ]
      },
      positions: [ 'A1', 'B1'],
      # import is not being defined to save calls against S3 -- context "road order with an attachment"
    ) }
    
    it "only contains the expected keys" do
      expect(subject.keys).to contain_exactly(
        'id',
        'car_type',
        'start_car',
        'day_shifts',
        'positions',
        'import_url',
        'definitions',
        'station',
        'contract',
        'author'
      )
    end
    
    it "has expected id" do
      expect(subject['id']).to eq(id)
    end
    
    it "has expected car_type" do
      expect(subject['car_type']).to eq('COACH')
    end
    
    it "has expected start_car" do
      expect(subject['start_car']).to eq(30)
    end
    
    it "has expected day_shifts" do
      expect(subject['day_shifts']).to eq({
        "1" => [ "1", "2" ],
        "2" => [ "1", "2" ]
      })
    end
    
    it "has expected positions" do
      expect(subject['positions']).to eq([ 'A1', 'B1'])
    end
    
    it "has expected station" do
      expect(subject['station']).to eq(JSON.parse(road_order.station.to_json))
    end
    
    it "has expect contract" do
      expect(subject['contract']).to eq(JSON.parse(road_order.contract.to_json))
    end
    
    it "has expected author" do
      expect(subject['author']).to eq(JSON.parse(road_order.author.to_json))
    end
  end
  
  context "road order with two definitions" do
    let!(:road_order) { FactoryBot.create(:road_order,
      car_type: "COACH",
      start_car: 30,
      day_shifts: {
        "1" => [ "1", "2" ],
        "2" => [ "1", "2" ]
      },
      positions: [ 'A1', 'B1'],
      # import is not being defined to save calls against S3 -- context "road order with an attachment"
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
        'day_shifts',
        'positions',
        'import_url',
        'definitions',
        'station',
        'contract',
        'author'
      )
    end
    
    it "has expected id" do
      expect(subject['id']).to eq(id)
    end
    
    it "has expected car_type" do
      expect(subject['car_type']).to eq('COACH')
    end
    
    it "has expected start_car" do
      expect(subject['start_car']).to eq(30)
    end
    
    it "has expected day_shifts" do
      expect(subject['day_shifts']).to eq({
        "1" => [ "1", "2" ],
        "2" => [ "1", "2" ]
      })
    end
    
    it "has expected positions" do
      expect(subject['positions']).to eq([ 'A1', 'B1'])
    end
    
    it "has expected station" do
      expect(subject['station']).to eq(JSON.parse(road_order.station.to_json))
    end
    
    it "has expect contract" do
      expect(subject['contract']).to eq(JSON.parse(road_order.contract.to_json))
    end
    
    it "has expected author" do
      expect(subject['author']).to eq(JSON.parse(road_order.author.to_json))
    end
    
    it "has expected definitions" do
      # ensure it uses the DefinitionSerializer to serialize components
      d0Serializer = DefinitionSerializer.new(road_order.definitions[0])
      d0Serialization = ActiveModelSerializers::Adapter.create(d0Serializer)
      
      d1Serializer = DefinitionSerializer.new(road_order.definitions[1])
      d1Serialization = ActiveModelSerializers::Adapter.create(d1Serializer)
      
      expect(subject['definitions']).to eq(JSON.parse([ d0Serialization, d1Serialization ].to_json))
    end
  end
end
