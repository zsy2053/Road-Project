FactoryBot.define do
  factory :definition do
    road_order
    sequence(:name) { |n| "task #{n}" }
    day "1"
    shift "Morning"
    expected_duration 1
    breaks 0
    serialized false
    work_location "Cloud"
    description "This is a very important job because if it is not it doesn't matter!!!"
    expected_start 18.days.ago
    expected_end 17.days.ago
    positions ["b1"]
  end
end