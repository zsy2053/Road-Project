require 'rails_helper'

RSpec.describe RoadOrder, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:road_order)).to be_valid
  end
  
  it { should belong_to(:station) }
  
  it { should belong_to(:contract) }
  
  it { should belong_to(:author) }
  
  it { should validate_presence_of :car_type }
  
  it { should validate_presence_of :start_car }
  
  it { should have_many :definitions }
  
  # Rails 5 prevents the following from being used
  #it { should serialize :positions }
  describe :positions do
    it "should serialize an array" do
      arr = [ "1", "2" ]
      x = FactoryBot.create(:road_order, positions: arr)
      x.reload
      expect(x.positions).to eq(arr)
    end
  end
  
  # Rails 5 prevents the following from being used
  #it { should serialize :day_shifts }
  describe :day_shifts do
    it "should serialize a has" do
      hsh = { "1" => [ "1", "2" ], "2" => [ "1", "2" ] }
      x = FactoryBot.create(:road_order, day_shifts: hsh)
      x.reload
      expect(x.day_shifts).to eq(hsh)
    end
  end
end
