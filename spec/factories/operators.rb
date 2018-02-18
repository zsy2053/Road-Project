FactoryBot.define do
  factory :operator do
    first_name "Alex_op"
    last_name "Boss_op"
    sequence(:badge) { |n| "badge#{n}" }
    sequence(:employee_number) { |n| "emp#{n}" }
    site
  end
end
