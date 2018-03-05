FactoryBot.define do
  factory :stop_reason do
  	sequence(:label) { |n| "Stop Reason #{n}" }
    should_alert false
	end
end
