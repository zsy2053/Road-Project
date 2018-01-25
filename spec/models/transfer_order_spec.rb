require 'rails_helper'

RSpec.describe TransferOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:transfer_order)).to be_valid
  end

  it { should belong_to(:contract) }

  it { should belong_to(:station) }

  it { should validate_presence_of(:to_number) }

  it { should validate_presence_of(:car) }

  it { should validate_presence_of(:order) }

  it { should validate_presence_of(:installation) }

  it { should validate_presence_of(:sort_string) }

  it { should validate_presence_of(:priority) }

  it { should validate_presence_of(:reason_code) }
  
  it "automatically assigns a contract if station present" do
    station = FactoryBot.create(:station)
    to = FactoryBot.build(:transfer_order, station: station, contract: nil)
    to.save!
    to.reload
    expect(to.contract).to eq(station.contract)
  end
  
  it "doesn't automatically assign a contract if station not present" do
    to = FactoryBot.build(:transfer_order, station: nil, contract: nil)
    expect(to.save).to be_falsey
    expect(to.contract).to be_blank
  end

end
