FactoryBot.define do
  factory :contract do
    site
    planned_start 17.months.ago
    planned_end 10.months.ago
    actual_start 16.months.ago
    actual_end 1.months.ago
    minimum_offset 1
  end
end