FactoryBot.define do
  factory :definition do
    road_order
    sequence(:name) { |n| "task #{n}" }
    sequence(:sequence_number) { |n| "SEQ#{n}" }
    day "1"
    shift "Morning"
    expected_duration 1
    breaks 0
    serialized false
  end
end