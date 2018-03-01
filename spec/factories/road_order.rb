FactoryBot.define do
  factory :road_order do
    station
    association :author, factory: :user
    car_type "BILEVEL"
    start_car 1
    work_centre "Bonding"
    sequence(:module) { "B" } # using sequence as a workaround because 'module' is a reserved word in rails
    positions []
    day_shifts {}
    version '1.0.0'

    after(:build) do |road_order|
      road_order.contract ||= road_order.station.contract
    end
  end
end
