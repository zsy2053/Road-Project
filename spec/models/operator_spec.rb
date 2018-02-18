require 'rails_helper'

RSpec.describe Operator, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:operator)).to be_valid
  end

  it { should validate_uniqueness_of(:employee_number) }

  it { should validate_uniqueness_of(:badge) }

  it { should validate_presence_of(:employee_number) }

  it { should validate_presence_of(:badge) }

  it { should belong_to(:site) }
  
  describe :position do
    it "can be set" do
      position = FactoryBot.create(:position)
      expect(FactoryBot.build(:operator, position: position)).to be_valid
    end
    
    it "can be null" do
      expect { FactoryBot.create(:operator, position: nil) }.not_to raise_error
    end
  end
end
