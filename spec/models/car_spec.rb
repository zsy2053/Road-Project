require 'rails_helper'

RSpec.describe Car, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:car)).to be_valid
  end
  
  it { should belong_to(:contract) }  

  it { should validate_presence_of :car_type }

  it { should validate_presence_of :number }
  it { should validate_numericality_of(:number).only_integer.is_greater_than(0) }
  
  it "should reject duplicate number for same car type within a contract" do
    contract = FactoryBot.create(:contract)
    car1 = FactoryBot.create(:car, contract: contract, car_type: "ABC", number: 1)
    car2 = FactoryBot.build(:car, contract: contract, car_type: "ABC", number: 1)
    expect(car2).to_not be_valid
    expect(car2.errors.messages[:number]).to eq(["has already been taken"])
  end
  
  it "should accept duplicate number for same car type within different contracts" do
    contract1 = FactoryBot.create(:contract)
    contract2 = FactoryBot.create(:contract, site: contract1.site)
    car1 = FactoryBot.create(:car, contract: contract1, car_type: "ABC", number: 1)
    car2 = FactoryBot.build(:car, contract: contract2, car_type: "ABC", number: 1)
    expect(car2).to be_valid
  end
  
  it "should accept duplicate number for different car types within a contract" do
    contract = FactoryBot.create(:contract)
    car1 = FactoryBot.create(:car, contract: contract, car_type: "ABC", number: 1)
    car2 = FactoryBot.build(:car, contract: contract, car_type: "DEF", number: 1)
    expect(car2).to be_valid
  end
  
  it "should accept duplicate number for different car types within different contract" do
    contract1 = FactoryBot.create(:contract)
    contract2 = FactoryBot.create(:contract, site: contract1.site)
    car1 = FactoryBot.create(:car, contract: contract1, car_type: "ABC", number: 1)
    car2 = FactoryBot.build(:car, contract: contract2, car_type: "DEF", number: 1)
    expect(car2).to be_valid
  end
end
