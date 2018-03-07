require 'rails_helper'

RSpec.describe Work, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:work)).to be_valid
  end

  it { should belong_to(:parent) }

  it { should belong_to(:contract) }
  
  it "should assign contract based on movement" do
    movement = FactoryBot.create(:movement)
    work = FactoryBot.create(:work, parent: movement, contract: nil)

    expect(work).to be_valid
  end

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

    it "cannot accept nil value" do
      timeString = nil
      expect(FactoryBot.build(:work, :override_time => timeString)).to_not be_valid
    end

    it "cannot accept bad input" do
      timeString = "something"
      a = FactoryBot.build(:work, :override_time => timeString)
      expect(FactoryBot.build(:work, :override_time => timeString)).to_not be_valid
    end
    
    it "can follow another work entry for the same operator" do
      time1 = 2.second.ago
      time2 = 1.second.ago
      expect(time2 > time1).to be_truthy
      
      timeString1 = time1.to_s
      timeString2 = time2.to_s
      
      movement = FactoryBot.create(:movement)
      contract = movement.definition.road_order.contract
      site = contract.site
      operator = FactoryBot.create(:operator, site: site)
      
      work1 = FactoryBot.create(:work, :contract => contract, :parent => movement, :operator => operator, :override_time => timeString1)
      
      work2 = FactoryBot.build(:work, :contract => contract, :parent => movement, :operator => operator, :override_time => timeString2)
      
      expect(work2).to be_valid
    end
    
    it "cannot preceed another work entry for the same operator" do
      time1 = 1.second.ago
      time2 = 2.second.ago
      expect(time2 < time1).to be_truthy
      
      timeString1 = time1.to_s
      timeString2 = time2.to_s
      
      movement = FactoryBot.create(:movement)
      contract = movement.definition.road_order.contract
      site = contract.site
      operator = FactoryBot.create(:operator, site: site)
      
      work1 = FactoryBot.create(:work, :contract => contract, :parent => movement, :operator => operator, :override_time => timeString1)
      
      work2 = FactoryBot.build(:work, :contract => contract, :parent => movement, :operator => operator, :override_time => timeString2)
      
      expect(work2).to_not be_valid
      # use floor since milliseconds are not captured
      expect(work2.errors[:override_time]).to eq([ 'cannot preceed last time entry of [' + time1.to_f.floor.to_s + ']' ])
    end
    
    it "can preceed another work entry for a different operator" do
      time1 = 1.second.ago
      time2 = 2.second.ago
      expect(time2 < time1).to be_truthy
      
      timeString1 = time1.to_s
      timeString2 = time2.to_s
      
      movement = FactoryBot.create(:movement)
      contract = movement.definition.road_order.contract
      site = contract.site
      operator1 = FactoryBot.create(:operator, site: site)
      operator2 = FactoryBot.create(:operator, site: site)
      
      work1 = FactoryBot.create(:work, :contract => contract, :parent => movement, :operator => operator1, :override_time => timeString1)
      
      work2 = FactoryBot.build(:work, :contract => contract, :parent => movement, :operator => operator2, :override_time => timeString2)
      
      expect(work2).to be_valid
    end
  end
end
