FactoryBot.define do
  factory :car do
    contract
    car_type "B"
    sequence(:number, 1)
  end
end