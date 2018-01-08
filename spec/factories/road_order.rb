FactoryBot.define do
  factory :road_order do
  	station
  	association :author, factory: :user
  	car_type "B"
  	start_car 1
	end
end
