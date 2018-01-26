FactoryBot.define do
  factory :transfer_order do
    station
    contract
    to_number "2"
    car "car"
    order 1
    installation "installation"
    sort_string "sort_string"
    priority "priority"
    reason_code "reason_code"
  end
end
