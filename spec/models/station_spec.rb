require 'rails_helper'

RSpec.describe Station, type: :model do
	it { should belong_to(:contract) }

  it "has a valid factory" do
    expect(FactoryBot.build(:station)).to be_valid
  end
end
