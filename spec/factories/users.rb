FactoryBot.define do
  factory :user do
    first_name "Alex"
    last_name "Boss"
    sequence(:email) { |n| "email#{n}@robinsonsolutions.com" }
    sequence(:username) {|n| "username#{n}" }
    sequence(:employee_id) { |n| 10000 + n }
    password "Qwer1234"
    site
    site_name_text "Oshawa"
    # use the roles collection to generate role specific factories
    User.roles.each do |key, value|
      factory :"#{value}_user" do
        role "#{value}"
      end
    end
  end
end
