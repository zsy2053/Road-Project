FactoryBot.define do
  factory :transfer_order do
    station
    contract
    to_number "to_number"
    car "car"
    order 1
    installation "installation"
    sort_string "sort_string"
    priority "priority"
    reason_code "reason_code"
  end
end
