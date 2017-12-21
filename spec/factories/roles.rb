FactoryBot.define do
  factory :role do
    factory :admin_role do
      name 'admin'
    end
    factory :method_engineer_role do
      name 'method_engineer'
    end
    factory :supervisor_role do
      name 'supervisor'
    end
    factory :quality_inspector_role do
      name 'quality_inspector'
    end
    factory :planner_role do
      name 'planner'
    end
    factory :station_role do
      name 'station'
    end
  end
end