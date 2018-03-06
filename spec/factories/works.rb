FactoryBot.define do
  factory :work do
    position
    contract
    operator
    association :parent, :factory => :movement
    actual_time Time.now
    action "Stop"
  end
end
