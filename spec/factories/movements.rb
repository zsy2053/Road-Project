FactoryBot.define do
  factory :movement do
    definition
    car_road_order
    actual_duration 0
    percent_complete 0
    production_critical false
    quality_critical false
  end
end
