require 'rails_helper'

RSpec.describe BackOrderSerializer, type: :serializer do
  let!(:contract) { FactoryBot.create(:contract, name: "Contract Name") }
  let!(:station) { FactoryBot.create(:station, contract: contract, name: "Station Name") }
  let(:back_order) { FactoryBot.create(:back_order, contract: contract, station: station) }
  let(:serializer) { described_class.new(back_order) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  
  let(:subject) { JSON.parse(serialization.to_json) }
    
  it 'only contains expected keys' do
    expect(subject.keys).to contain_exactly(
      'id',
      'contract',
      'contract_name',
      'station',
      'station_name',
      'bom_exp_no',
      'mrp_cont',
      'cri',
      'component',
      'material_description',
      'sort_string',
      'assembly',
      'order',
      'item_text_line_1',
      'qty',
      'vendor_name',
      'focused_part_flag'
    )
  end
  
  it 'should have an id that matches' do
    expect(subject['id']).to eq(back_order.id)
  end
  
  it 'should have a contract name that matches' do
    expect(subject['contract_name']).to eq(back_order.contract.name)
  end
  
  it 'should have a station name that matches' do
    expect(subject['station_name']).to eq(back_order.station.name)
  end
  
  it 'should have a bom_exp_no that matches' do
    expect(subject['bom_exp_no']).to eq(back_order.bom_exp_no)
  end
  
  it 'should have a mrp_cont that matches' do
    expect(subject['mrp_cont']).to eq(back_order.mrp_cont)
  end

  it 'should have cri that matches' do
    expect(subject['cri']).to eq(back_order.cri)
  end
  
  it 'should have a component that matches' do
    expect(subject['component']).to eq(back_order.component)
  end
  
  it 'should have a material_description that matches' do
    expect(subject['material_description']).to eq(back_order.material_description)
  end
  
  it 'should have sort_string that matches' do
    expect(subject['sort_string']).to eq(back_order.sort_string)
  end
  
  it 'should have a assembly that matches' do
    expect(subject['assembly']).to eq(back_order.assembly)
  end
  
  it 'should have a order that matches' do
    expect(subject['order']).to eq(back_order.order)
  end

  it 'should have item_text_line_1 that matches' do
    expect(subject['item_text_line_1']).to eq(back_order.item_text_line_1)
  end
  
  it 'should have a qty that matches' do
    expect(subject['qty']).to eq(back_order.qty)
  end
  
  it 'should have a vendor_name that matches' do
    expect(subject['vendor_name']).to eq(back_order.vendor_name)
  end
  
  it 'should have focused_part_flag that matches' do
    expect(subject['focused_part_flag']).to eq(back_order.focused_part_flag)
  end
  
end