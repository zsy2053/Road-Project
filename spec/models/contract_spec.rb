require 'rails_helper'

RSpec.describe Contract, type: :model do
  it { should belong_to(:site) }

  it "has a valid factory" do
    expect(FactoryBot.build(:contract)).to be_valid
  end
  
  it { should validate_presence_of :minimum_offset }
  it { should validate_numericality_of(:minimum_offset).only_integer.is_greater_than(0) }
  
  describe "status attribute" do
    before(:each) do
      @contract = FactoryBot.create(:contract)
    end

    it "should be draft by defult." do
      expect(@contract.draft?).to be true
    end

    it "could change to open." do
      expect(@contract.draft?).to be true
      @contract.open!
      expect(@contract.open?).to be true
    end

    it "could change to closed." do
      expect(@contract.draft?).to be true
      @contract.closed!
      expect(@contract.closed?).to be true
    end

    it "should get a error if wrong value being assigned" do
      expect{ @contract.status = "A" }.to raise_error(ArgumentError)
    end
  end
end
