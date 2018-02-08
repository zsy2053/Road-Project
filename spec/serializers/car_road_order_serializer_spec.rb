require 'rails_helper'

RSpec.describe CarRoadOrderSerializer, type: :serializer do
  let(:car_road_order) { FactoryBot.create(:car_road_order) }
  let(:serializer) { described_class.new(car_road_order) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }
    
  it 'only contains expected keys' do
    expect(subject.keys).to contain_exactly(
      'id',
      'car',
      'contract',
      'station',
      'road_order',
      'positions',
      'movements'
    )
  end
end