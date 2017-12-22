FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@robinsonsolutions.com" }
    sequence(:username) {|n| "username#{n}" }
    password "Qwer1234"
    site

    # use the roles collection to generate role specific factories
    User.roles.each do |key, value|
      factory :"#{value}_user" do
        role "#{value}"
      end
    end
  end
end
