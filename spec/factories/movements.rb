# spec/factories/movements.rb
FactoryBot.define do
  factory :movement do
		actual_duration 3
		percent_complete 0.5
		number_operators 1
		comments "This is a comments."
  end
end