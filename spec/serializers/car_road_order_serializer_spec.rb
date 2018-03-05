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

  context "position attributes" do
    let(:operator2) { FactoryBot.create(:operator)}
    let(:position2) { FactoryBot.create(:position, operators: [operator2]) }
    let(:car_road_order2) { FactoryBot.create(:car_road_order, positions: [position2] ) }
    let(:serializer2) { described_class.new(car_road_order2) }
    let(:serialization2) { ActiveModelSerializers::Adapter.create(serializer2) }

    let(:subject2) { JSON.parse(serialization2.to_json) }
    it 'only contains expect keys' do
      expect(subject2['positions'][0].keys).to contain_exactly(
      'id',
      'name',
      'allows_multiple',
      'operators'
      )
    end

    it 'verify operators' do
      expect(subject2['positions'][0]['operators'][0].keys).to contain_exactly(
      'first_name',
      'last_name',
      'employee_number',
      'badge', # TODO this should not be here
      'suspended',
      'created_at',
      'updated_at',
      'id',
      'position_id',
      'movement_id',
      'site_id'
      )
      expect(subject2['positions'][0]['operators'][0]['first_name']).to eq(operator2.first_name)
      expect(subject2['positions'][0]['operators'][0]['last_name']).to eq(operator2.last_name)
      expect(subject2['positions'][0]['operators'][0]['employee_number']).to eq(operator2.employee_number)
      expect(subject2['positions'][0]['operators'][0]['badge']).to eq(operator2.badge)
      expect(subject2['positions'][0]['operators'][0]['suspended']).to eq(operator2.suspended)
      expect(subject2['positions'][0]['operators'][0]['id']).to eq(operator2.id)
      expect(subject2['positions'][0]['operators'][0]['position_id']).to eq(position2.id)
      expect(subject2['positions'][0]['operators'][0]['site_id']).to eq(operator2.site_id)
    end
  end
end
