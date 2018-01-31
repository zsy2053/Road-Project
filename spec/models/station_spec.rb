require 'rails_helper'

RSpec.describe Station, type: :model do
	it { should belong_to(:contract) }

  it "has a valid factory" do
    expect(FactoryBot.build(:station)).to be_valid
  end
  
  describe "name attributes" do
    let!(:contract) { FactoryBot.create(:contract) }
    let!(:station1) { FactoryBot.create(:station, name: "Station 1", contract: contract) }
    
    it "should validate uniqueness of station's name within a contract" do
      station2 = FactoryBot.build(:station, name: "Station 1", contract: contract)
      expect { station2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "should not validate uniqueness of station's name across contracts" do
      expect(FactoryBot.build(:station, name: "Station 1")).to be_valid
    end
  end
  
  describe "code attributes" do
    let!(:contract) { FactoryBot.create(:contract) }
    let!(:station1) { FactoryBot.create(:station, code: "S1", contract: contract) }
    
    it "should validate uniqueness of station's code within a contract" do
      station2 = FactoryBot.build(:station, code: "S1", contract: contract)
      expect { station2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "should not validate uniqueness of station's code across contracts" do
      expect(FactoryBot.build(:station, code: "S1")).to be_valid
    end
  end  

end
