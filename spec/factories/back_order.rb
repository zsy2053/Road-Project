FactoryBot.define do
  factory :back_order do
    station
    after(:build) do |back_order|
      back_order.contract ||= back_order.station.contract
    end
  end
end
