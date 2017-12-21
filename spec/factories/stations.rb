FactoryBot.define do
  factory :station do
  	contract
  	sequence(:name) { |n| "Station#{n}" }
  	code "A"
	end
end