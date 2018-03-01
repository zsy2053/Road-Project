require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { FactoryBot.create(:user, site: FactoryBot.create(:site), role: "admin") }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }
    
  it 'only contains expected keys' do
    expect(subject.keys).to contain_exactly(
      'id',
      'first_name',
      'last_name',
      'employee_id',
      'phone',
      'email',
      'username',
      'role',
      'site_id',
      'site_name',
      'contracts',
      'suspended',
      'site_name_text'
    )
  end
  
  it 'should have an id that matches' do
    expect(subject['id']).to eq(user.id)
  end
  
  it 'should have a first name that matches' do
    expect(subject['first_name']).to eq(user.first_name)
  end
  
  it 'should have a last name that matches' do
    expect(subject['last_name']).to eq(user.last_name)
  end
  
  it 'should have an employee id that matches' do
    expect(subject['employee_id']).to eq(user.employee_id)
  end
  
  it 'should have a username that matches' do
    expect(subject['username']).to eq(user.username)
  end

  it 'should have a site name that matches' do
    expect(subject['site_name']).to eq(user.site.name)
  end
  
  it 'should have a role that matches' do
    expect(subject['role']).to eq(user.role)
  end
  
  it 'should have a site_id name that matches' do
    expect(subject['site_id']).to eq(user.site.id)
  end
  
  it 'should have an email that matches' do
    expect(subject['email']).to eq(user.email)
  end
  
  it 'should have an array of contracts that matches and has the access id of the access record for this contract and user' do
    contracts = [ FactoryBot.create(:contract, site: user.site, status: "open"), FactoryBot.create(:contract, site: user.site, status: "open") ]
    accesses = [ FactoryBot.create(:access, user: user, contract: contracts[0]), FactoryBot.create(:access, user: user, contract: contracts[1]) ]
    
    expected_contracts = subject['contracts']
    # updated_at and create_at has a different format when active record is converted to json by as_json, so I excluded them in comparison 
    expect([expected_contracts[0]['access_id'],expected_contracts[0]['site_id'], expected_contracts[0]['status'], expected_contracts[0]['name'], expected_contracts[0]['code']]).to eq([accesses[0].id,contracts[0]['site_id'], contracts[0]['status'], contracts[0]['name'], contracts[0]['code']])
    expect([expected_contracts[1]['access_id'],expected_contracts[1]['site_id'], expected_contracts[1]['status'], expected_contracts[1]['name'], expected_contracts[1]['code']]).to eq([accesses[1].id,contracts[1]['site_id'], contracts[1]['status'], contracts[1]['name'], contracts[1]['code']])
  end
  
  it 'should have a site_name_text that matches' do
    expect(subject['site_name_text']).to eq(user.site_name_text)
  end
end