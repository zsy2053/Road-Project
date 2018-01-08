require 'rails_helper'

RSpec.describe RoadOrder, type: :model do
  it { should belong_to(:station) }
  it { should have_one(:contract) }
  it { should belong_to(:author) }
  it { should validate_presence_of :car_type }
  it { should validate_presence_of :start_car }

  it "has a valid factory" do
    expect(FactoryBot.build(:road_order)).to be_valid
  end
end
