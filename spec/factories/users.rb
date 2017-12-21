FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@robinsonsolutions.com" }
    sequence(:username) {|n| "Donald_Trump#{n}" }
    site
    password "Qwer1234"
  end
end
