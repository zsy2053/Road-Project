require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { FactoryBot.create(:user, site: FactoryBot.create(:site), role: "admin") }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'should have a site name that matches' do
    expect(subject['site_name']).to eql(user.site.name)
  end
  
  it 'should have a role that matches' do
    expect(subject['role']).to eql(user.role)
  end
  
  it 'should have a site_id name that matches' do
    expect(subject['site_id']).to eql(user.site.id)
  end
  
  it 'should have an email that matches' do
    expect(subject['email']).to eql(user.email)
  end
  
  it 'should have an array of contracts that matches' do
    contracts = [ FactoryBot.create(:contract, site: user.site, status: "open"), FactoryBot.create(:contract, site: user.site, status: "open") ]
    accesses = [ FactoryBot.create(:access, user: user, contract: contracts[0]), FactoryBot.create(:access, user: user, contract: contracts[1]) ]
    
    expected_contracts = subject['contracts']
    # updated_at and create_at has a different format when active record is converted to json by as_json, so I excluded them in comparison 
    expect([expected_contracts[0]['site_id'], expected_contracts[0]['status'], expected_contracts[0]['name'], expected_contracts[0]['code']]).to eql([contracts[0]['site_id'], contracts[0]['status'], contracts[0]['name'], contracts[0]['code']])
    expect([expected_contracts[1]['site_id'], expected_contracts[1]['status'], expected_contracts[1]['name'], expected_contracts[1]['code']]).to eql([contracts[1]['site_id'], contracts[1]['status'], contracts[1]['name'], contracts[1]['code']])
  end
end