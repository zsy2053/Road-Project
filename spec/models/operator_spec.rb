require 'rails_helper'

RSpec.describe Operator, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:operator)).to be_valid
  end

  it { should validate_uniqueness_of(:employee_number) }

  it { should validate_uniqueness_of(:badge) }

  it { should validate_presence_of(:employee_number) }

  it { should validate_presence_of(:badge) }
end
