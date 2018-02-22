require 'rails_helper'

RSpec.describe PositionSerializer, type: :serializer do
  let!(:position1) { FactoryBot.create(:position) }
  let(:serializer) { described_class.new(position1) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it "only contains the expected keys" do
    expect(subject.keys).to contain_exactly(
      'id', 'name', 'allows_multiple', 'operators'
    )
  end

  it "should have an id that matches" do
    expect(subject['id']).to eq(position1.id)
  end

  it "should have a name value that matches" do
    expect(subject['name']).to eq(position1.name)
  end

  it "should have a allows_multiple that matches" do
    expect(subject['allows_multiple']).to eq(position1.allows_multiple)
  end

  it "should have an operators that matches" do
    expect(subject['operators']).to eq(position1.operators)
  end
end
