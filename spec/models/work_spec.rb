require 'rails_helper'

RSpec.describe Work, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:work)).to be_valid
  end

  it { should belong_to(:parent) }

  it { should belong_to(:contract) }

  it { should belong_to(:operator) }

  it { should validate_presence_of :action }

  it { should validate_presence_of :position}

  it { should validate_presence_of :completion }
  it { should validate_numericality_of(:completion).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }

  describe :parent_type do
    # it "can be set to Snag" do
    #   expect(FactoryBot.build(:work, :parent_type => "Snag")).to be_valid
    # end

    it "can be set to Movement" do
      expect(FactoryBot.build(:work, :parent_type => "Movement")).to be_valid
    end

    it "cannot be set to other strings" do
      expect{ FactoryBot.create(:work, :parent_type => "something") }.to raise_error(NameError)
    end

    it "cannot be set to nil" do
      expect(FactoryBot.build(:work, :parent_type => nil)).to_not be_valid
    end
  end

  describe :actual_time do
    it "should be a date time" do
      timeString = "2018-03-06 14:43:13 UTC"
      work_record = FactoryBot.build(:work, :actual_time => timeString)
      expect(work_record).to be_valid
      # must convert to string for comparison
      expect(work_record.actual_time.to_s).to eq(timeString)
    end

    it "cannot accept nil value" do
      timeString = nil
      expect(FactoryBot.build(:work, :actual_time => timeString)).to_not be_valid
    end

    it "cannot accept bad input" do
      timeString = "something"
      expect(FactoryBot.build(:work, :actual_time => timeString)).to_not be_valid
    end
  end

  describe :override_time do
    it "should be a date time" do
      timeString = "2018-03-06 14:43:13 UTC"
      work_record = FactoryBot.build(:work, :override_time => timeString)
      expect(work_record).to be_valid
      # must convert to string for comparison
      expect(work_record.override_time.to_s).to eq(timeString)
    end

    it "can accept nil value" do
      timeString = nil
      expect(FactoryBot.build(:work, :override_time => timeString)).to be_valid
    end

    it "cannot accept bad input" do
      timeString = "something"
      a = FactoryBot.build(:work, :override_time => timeString)
      puts a.override_time
      expect(FactoryBot.build(:work, :override_time => timeString)).to_not be_valid
    end
  end
end
