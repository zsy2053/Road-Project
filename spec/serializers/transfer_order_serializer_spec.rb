require 'rails_helper'

RSpec.describe TransferOrderSerializer, type: :serializer do
  let!(:station1) { FactoryBot.create(:station, :name => "station 1") }
  let(:contract1) { station1.contract }
  let!(:assembly) { FactoryBot.create(:car, :contract => contract1) }
  let!(:transfer_order1) { FactoryBot.create(:transfer_order, :contract_id => contract1.id, :station_id => station1.id, :assembly => assembly) }
  let(:serializer) { described_class.new(transfer_order1) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it "only contains the expected keys" do
    expect(subject.keys).to contain_exactly(
      'id',
      'to_number',
      'car',
      'order',
      'installation',
      'sort_string',
      'date_entered',
      'date_received_3pl',
      'date_staging',
      'date_shipped_bt',
      'date_received_bt',
      'date_production',
      'delivery_device',
      'priority',
      'reason_code',
      'station',
      'contract',
      'assembly'
    )
  end

    it "should have an id that matches" do
      expect(subject['id']).to eq(transfer_order1.id)
    end

    it "should have a to_number value that matches" do
      expect(subject['to_number']).to eq(transfer_order1.to_number)
    end

    it "should have a car that matches" do
      expect(subject['car']).to eq(transfer_order1.car)
    end

    it "should have an order that matches" do
      expect(subject['order']).to eq(transfer_order1.order)
    end

    it "should have an installation that matches" do
      expect(subject['installation']).to eq(transfer_order1.installation)
    end

    it "should have a sort_string that matches" do
      expect(subject['sort_string']).to eq(transfer_order1.sort_string)
    end

    it "should have a date_entered that matches" do
      expect(subject['date_entered']).to eq(transfer_order1.date_entered)
    end

    it "should have a date_received_3pl that matches" do
      expect(subject['date_received_3pl']).to eq(transfer_order1.date_received_3pl)
    end

    it "should have a date_staging that matches" do
      expect(subject['date_staging']).to eq(transfer_order1.date_staging)
    end

    it "should have a date_shipped_bt that matches" do
      expect(subject['date_shipped_bt']).to eq(transfer_order1.date_shipped_bt)
    end

    it "should have a date_received_bt that matches" do
      expect(subject['date_received_bt']).to eq(transfer_order1.date_received_bt)
    end

    it "should have a date_production that matches" do
      expect(subject['date_production']).to eq(transfer_order1.date_production)
    end

    it "should have a delivery_device that matches" do
      expect(subject['delivery_device']).to eq(transfer_order1.delivery_device)
    end

    it "should have a priority that matches" do
      expect(subject['priority']).to eq(transfer_order1.priority)
    end

    it "should have a reason_code that matches" do
      expect(subject['reason_code']).to eq(transfer_order1.reason_code)
    end

    it "should have a station that matches" do
      expect(subject['station']['id']).to eq(transfer_order1.station.id)
    end

    it "should have a contract that matches" do
      expect(subject['contract']['id']).to eq(transfer_order1.contract.id)
    end

    it "should have an assembly that matches" do
      expect(subject['assembly']['id']).to eq(transfer_order1.assembly.id)
    end
end
