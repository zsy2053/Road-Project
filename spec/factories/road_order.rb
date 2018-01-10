FactoryBot.define do
  factory :road_order do
  	station
  	contract
  	association :author, factory: :user
  	car_type "B"
  	start_car 1
	end
end
