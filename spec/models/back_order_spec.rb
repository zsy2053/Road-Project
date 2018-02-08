require 'rails_helper'

RSpec.describe BackOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:back_order)).to be_valid
  end
  
  it { should belong_to(:station) }
  
  it { should belong_to(:contract) }
  
  describe :cri do
    it "should accept 'true'" do
      expect(FactoryBot.build(:back_order, :cri => true)).to be_valid
    end
    
    it "should accept 'false'" do
      expect(FactoryBot.build(:back_order, :cri => false)).to be_valid
    end
    
    it "should not accept nil" do
      expect(FactoryBot.build(:back_order, :cri => nil)).to_not be_valid
    end
  end
  
  describe :focused_part_flag do
    it "should accept 'true'" do
      expect(FactoryBot.build(:back_order, :focused_part_flag => true)).to be_valid
    end
    
    it "should accept 'false'" do
      expect(FactoryBot.build(:back_order, :focused_part_flag => false)).to be_valid
    end
    
    it "should not accept nil" do
      expect(FactoryBot.build(:back_order, :focused_part_flag => nil)).to_not be_valid
    end
  end
  
  
end