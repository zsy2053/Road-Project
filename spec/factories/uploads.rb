FactoryBot.define do
  factory :upload do
    category 'category'
    sequence(:filename) { |n| "file#{n}.txt" }
    content_type 'text/plain'
    status 'draft'
    user
  end
end
