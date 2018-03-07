FactoryBot.define do
  factory :work do
    position "A1"
    contract
    operator
    association :parent, :factory => :movement
    actual_time Time.now
    override_time Time.now
    action "Stop"
  end
end
