require 'rails_helper'

RSpec.describe Definition, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:definition)).to be_valid
  end
  
  it { should belong_to(:road_order) }
  
  it { should validate_presence_of(:name) }
  
  it { should validate_presence_of(:sequence_number) }
  
  it { should validate_presence_of(:day) }
  
  it { should validate_presence_of(:shift) }
  
  it { should validate_presence_of(:expected_duration) }
  it { should validate_numericality_of(:expected_duration).only_integer.is_greater_than_or_equal_to(0) }
  
  it { should validate_presence_of(:breaks) }
  it { should validate_numericality_of(:breaks).only_integer.is_greater_than_or_equal_to(0) }
  
  describe :serialized do
    it "should accept 'true'" do
      expect(FactoryBot.build(:definition, :serialized => true)).to be_valid
    end
    
    it "should accept 'false'" do
      expect(FactoryBot.build(:definition, :serialized => false)).to be_valid
    end
    
    it "should not accept nil" do
      expect(FactoryBot.build(:definition, :serialized => nil)).to_not be_valid
    end
  end
  
  describe :expected_start do
    it "should be a dateless time" do
      timeString = "13:14:15"
      definition = FactoryBot.build(:definition, :expected_start => timeString)
      # must convert to string for comparison
      expect(definition.expected_start.to_s).to eq(timeString)
    end
  end
  
  describe :expected_end do
    it "should be a dateless time" do
      timeString = "13:14:15"
      definition = FactoryBot.build(:definition, :expected_end => timeString)
      # must convert to string for comparison
      expect(definition.expected_end.to_s).to eq(timeString)
    end
  end
  
  # Rails 5 prevents the following from being used
  #it { should serialize :positions }
  describe :positions do
    it "should serialize an array" do
      arr = [ "1", "2" ]
      x = FactoryBot.create(:definition, positions: arr)
      x.reload
      expect(x.positions).to eq(arr)
    end
  end
end
