FactoryBot.define do
  factory :station do
  	contract
  	sequence(:name) { |n| "station #{n}" }
    sequence(:code) { |n| "ST#{n}" }
	end
end
