require 'rails_helper'

RSpec.describe PositionSerializer, type: :serializer do
  context "for a position with no operators" do
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

    it "should have operators that matches" do
      expect(subject['operators']).to eq(position1.operators)
      expect(subject['operators']).to be_a_kind_of(Array)
      expect(subject['operators'].length).to eq(0)
    end
  end

  context "for a position with only one operators" do
    let!(:operator1) { FactoryBot.create(:operator) }
    let!(:position1) { FactoryBot.create(:position, :operators => [operator1]) }
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
      expect(subject['operators'].as_json).to include(operator1.as_json)
      expect(subject['operators']).to be_a_kind_of(Array)
      expect(subject['operators'].length).to eq(1)
    end
  end

  context "for a position with two operators" do
    let!(:operator1) { FactoryBot.create(:operator) }
    let!(:operator2) { FactoryBot.create(:operator) }
    let!(:position1) { FactoryBot.create(:position, :operators => [operator1, operator2], :allows_multiple => true) }
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
      expect(subject['operators'].as_json).to include(operator1.as_json)
      expect(subject['operators'].as_json).to include(operator2.as_json)
      expect(subject['operators']).to be_a_kind_of(Array)
      expect(subject['operators'].length).to eq(2)
    end
  end
end
