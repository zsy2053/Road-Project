FactoryBot.define do
  factory :position do
    car_road_order
    sequence(:name) { |n| "position#{n}" }
  end
end
