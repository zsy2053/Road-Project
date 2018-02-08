FactoryBot.define do
  factory :back_order do
    station
    cri true
    focused_part_flag true
    after(:build) do |back_order|
      back_order.contract ||= back_order.station.contract
    end
  end
end
