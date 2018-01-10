FactoryBot.define do
  factory :road_order do
    station
    association :author, factory: :user
    car_type "B"
    start_car 1
    
    after(:build) do |road_order|
      road_order.contract ||= road_order.station.contract
    end
  end
end
