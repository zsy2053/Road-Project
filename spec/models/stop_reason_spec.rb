require 'rails_helper'

RSpec.describe StopReason, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:stop_reason)).to be_valid
  end

  it { should validate_presence_of(:label) }

  it { should validate_uniqueness_of(:label) }

  describe :should_alert do
    it "should accept 'true'" do
      expect(FactoryBot.build(:stop_reason, :should_alert => true)).to be_valid
    end

    it "should accept 'false'" do
      expect(FactoryBot.build(:stop_reason, :should_alert => false)).to be_valid
    end

    it "should not accept nil" do
      expect(FactoryBot.build(:stop_reason, :should_alert => nil)).to_not be_valid
    end
  end
end
