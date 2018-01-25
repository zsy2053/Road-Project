require 'rails_helper'

RSpec.describe BackOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:back_order)).to be_valid
  end
  
  it { should belong_to(:station) }
  
  it { should belong_to(:contract) }
end