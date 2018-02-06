require 'rails_helper'

RSpec.describe OperatorSerializer, type: :serializer do
  let!(:operator1) { FactoryBot.create(:operator) }
  let(:serializer) { described_class.new(operator1) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it "only contains the expected keys" do
    expect(subject.keys).to contain_exactly(
      'id', 'first_name', 'last_name', 'employee_number', 'suspended'
    )
  end

  it "should have an id that matches" do
    expect(subject['id']).to eq(operator1.id)
  end

  it "should have a first_name value that matches" do
    expect(subject['first_name']).to eq(operator1.first_name)
  end

  it "should have a last_name that matches" do
    expect(subject['last_name']).to eq(operator1.last_name)
  end

  it "should have an employee_number that matches" do
    expect(subject['employee_number']).to eq(operator1.employee_number)
  end

  it "should have an suspended that matches" do
    expect(subject['suspended']).to eq(operator1.suspended)
  end
end
