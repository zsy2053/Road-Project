require 'rails_helper'

RSpec.describe Access, type: :model do
  it { should belong_to(:user) }

  it { should belong_to(:contract) }

  it "has a valid factory" do
    expect(FactoryBot.build(:access)).to be_valid
  end

  it "cannot duplicate a user-contract pair" do
	  access1 = FactoryBot.create(:access)
	  access2 = FactoryBot.build(:access, user: access1.user, contract: access1.contract)
	  expect(access2).not_to be_valid
	end
end
