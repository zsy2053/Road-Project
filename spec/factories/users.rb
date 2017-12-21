FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@robinsonsolutions.com" }
    sequence(:first_name) {|n| "Donald_#{n}" }
    sequence(:last_name) {|n| "Trump_#{n}" }
    password "Qwer1234"
  end
end
