require 'rails_helper'

RSpec.describe Movement, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:movement)).to be_valid
  end

  it { should belong_to(:definition) }

  it { should belong_to(:car_road_order) }

  it { should validate_presence_of :actual_duration }
  it { should validate_numericality_of(:actual_duration).only_integer.is_greater_than_or_equal_to(0) }
  it { should have_many(:works) }

  it { should validate_presence_of :percent_complete }
  it { should validate_numericality_of(:percent_complete).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }

  it "should reject duplicate records for the same car road order and definition pair" do
    movement1 = FactoryBot.create(:movement)
    movement2 = FactoryBot.build(:movement, :definition_id => movement1.definition_id, :car_road_order_id => movement1.car_road_order_id)

    expect(movement2).to_not be_valid
    expect(movement2.errors.messages[:definition_id]).to eq(['has already been taken'])
  end

  it "should allow records for the same car road order and different definitions" do
    definition1 = FactoryBot.create(:definition)
    definition2 = FactoryBot.create(:definition, road_order: definition1.road_order)

    car_road_order = FactoryBot.create(:car_road_order, road_order: definition1.road_order)

    movement1 = FactoryBot.create(:movement, definition: definition1, car_road_order: car_road_order)
    movement2 = FactoryBot.create(:movement, definition: definition2, car_road_order: car_road_order)

    expect(movement2).to be_valid
  end

  it "should allow records for different car road orders and the same definition" do
    definition = FactoryBot.create(:definition)

    car_road_order1 = FactoryBot.create(:car_road_order, road_order: definition.road_order)
    car_road_order2 = FactoryBot.create(:car_road_order, road_order: definition.road_order)

    movement1 = FactoryBot.create(:movement, definition: definition, car_road_order: car_road_order1)
    movement2 = FactoryBot.create(:movement, definition: definition, car_road_order: car_road_order2)

    expect(movement2).to be_valid
  end

  it "should allow records for different car road orders and different definitions" do
    definition1 = FactoryBot.create(:definition)
    definition2 = FactoryBot.create(:definition, road_order: definition1.road_order)

    car_road_order1 = FactoryBot.create(:car_road_order, road_order: definition1.road_order)
    car_road_order2 = FactoryBot.create(:car_road_order, road_order: definition2.road_order)

    movement1 = FactoryBot.create(:movement, definition: definition1, car_road_order: car_road_order1)
    movement2 = FactoryBot.create(:movement, definition: definition2, car_road_order: car_road_order2)

    expect(movement2).to be_valid
  end
end
