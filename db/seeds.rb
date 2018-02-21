require 'factory_bot_rails'
site             = FactoryBot.create(:site, name: "Toronto", number: "CA99", address_line_1: "390 Bay Street", address_line_2: "Suite 1520", city: "Toronto", province: "Ontario", post_code: "M5H 2Y2", country: "Canada", time_zone: "America/New_York")

contract1        = FactoryBot.create(:contract, :name => "Edmonton", :code => "C0260", :description => "Edmonton", :site_id => site.id, :minimum_offset => 2)
contract2        = FactoryBot.create(:contract, :name => "TTC", :code => "C0248", :description => "Toronto Transit Commission", :site_id => site.id, :minimum_offset => 2)
contract3        = FactoryBot.create(:contract, :name => "Metrolinx", :code => "C0263", :description => "Metrolinx", :site_id => site.id, :minimum_offset => 2)

station1         = FactoryBot.create(:station, :name => "SA10", :code => "SA10", :contract_id => contract1.id)
station2         = FactoryBot.create(:station, :name => "SA20", :code => "SA20", :contract_id => contract1.id)
station3         = FactoryBot.create(:station, :name => "SB11", :code => "SB11", :contract_id => contract2.id)
station4         = FactoryBot.create(:station, :name => "SB21", :code => "SB21", :contract_id => contract2.id)
station5         = FactoryBot.create(:station, :name => "SC12", :code => "SC12", :contract_id => contract3.id)
station6         = FactoryBot.create(:station, :name => "SC22", :code => "SC22", :contract_id => contract3.id)

supervisor1      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Alex", :last_name => "Anderson", :employee_id => "20933", :username => "supervisor.alex", :email => "alex.anderson@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
supervisor2      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Heidi", :last_name => "Harris", :employee_id => "20913", :username => "supervisor.heidi", :email => "heidi.harris@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
supervisor3      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Idriss", :last_name => "Ion", :employee_id => "83822", :username => "supervisor.idriss", :email => "idriss.ion@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

super_admin1     = FactoryBot.create(:super_admin_user, :site_id => site.id, :first_name => "Bill", :last_name => "Brooks", :employee_id => "39394", :username => "superadmin.bill", :email => "bill.brooks@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

admin1           = FactoryBot.create(:admin_user, :site_id => site.id, :first_name => "Cindy", :last_name => "Clark", :employee_id => "88454", :username => "admin.cindy", :email => "cindy.clark@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

method_engineer1 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :first_name => "Debbie", :last_name => "Donalds", :employee_id => "48483", :username => "me.debbie", :email => "debbie.donalds@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
method_engineer2 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :first_name => "Florence", :last_name => "Fawks", :employee_id => "84443", :username => "me.florence", :email => "florence.fawks@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

planner1         = FactoryBot.create(:planner_user, :site_id => site.id, :first_name => "Eric", :last_name => "Earl", :employee_id => "31223", :username => "planner.eric", :email => "eric.earl@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
qa1              = FactoryBot.create(:quality_user, :site_id => site.id, :first_name => "Greg", :last_name => "Gagner", :employee_id => "23234", :username => "qa.greg", :email => "greg.gagner@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

access1          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract1.id)
access2          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract2.id)
access3          = FactoryBot.create(:access, :user_id => method_engineer2.id, :contract_id => contract1.id)
access4          = FactoryBot.create(:access, :user_id => method_engineer2.id, :contract_id => contract3.id)

access5          = FactoryBot.create(:access, :user_id => supervisor1.id, :contract_id => contract1.id)
access6          = FactoryBot.create(:access, :user_id => supervisor2.id, :contract_id => contract2.id)
access7          = FactoryBot.create(:access, :user_id => supervisor2.id, :contract_id => contract3.id)

station1_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SA10", :last_name => "SA10", :employee_id => "SA10", :username => "SA10", :email => "SA10@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
station2_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SA20", :last_name => "SA20", :employee_id => "SA20", :username => "SA20", :email => "SA20@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
station3_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SB11", :last_name => "SB11", :employee_id => "SB11", :username => "SB11", :email => "SB11@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
station4_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SB21", :last_name => "SB21", :employee_id => "SB21", :username => "SB21", :email => "SB21@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
station5_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SC12", :last_name => "SC12", :employee_id => "SC12", :username => "SC12", :email => "SC12@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
station6_user    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "SC22", :last_name => "SC22", :employee_id => "SC22", :username => "SC22", :email => "SC22@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

station1_access  = FactoryBot.create(:access, :user_id => station1_user.id, :contract_id => contract1.id)
station2_access  = FactoryBot.create(:access, :user_id => station2_user.id, :contract_id => contract1.id)
station3_access  = FactoryBot.create(:access, :user_id => station3_user.id, :contract_id => contract2.id)
station4_access  = FactoryBot.create(:access, :user_id => station4_user.id, :contract_id => contract2.id)
station5_access  = FactoryBot.create(:access, :user_id => station5_user.id, :contract_id => contract3.id)
station6_access  = FactoryBot.create(:access, :user_id => station6_user.id, :contract_id => contract3.id)

day_shifts = {
  '1' => [
    { :shift => '1', :start => '07:00:00', :end => '13:00:00' },
    { :shift => '2', :start => '13:00:00', :end => '19:00:00' }
  ],
  '2' => [
    { :shift => '1', :start => '07:00:00', :end => '13:00:00' },
    { :shift => '2', :start => '13:00:00', :end => '19:00:00' }
  ]
}

station1_ro1     = FactoryBot.create(:road_order, :station_id => station1.id, :contract_id => station1.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "A", :car_type => "Type 1", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)
station1_ro2     = FactoryBot.create(:road_order, :station_id => station1.id, :contract_id => station1.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "A", :car_type => "Type 1", :start_car => 4, :positions => [ 'A1', 'B1', 'C1', 'D1' ], :day_shifts => day_shifts)
station1_ro3     = FactoryBot.create(:road_order, :station_id => station1.id, :contract_id => station1.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "B", :car_type => "Type 2", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)

station2_ro1     = FactoryBot.create(:road_order, :station_id => station2.id, :contract_id => station2.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "A", :car_type => "Type 1", :start_car => 1, :positions => [ 'A1', 'B1', 'C1', 'D1' ], :day_shifts => day_shifts)
station2_ro2     = FactoryBot.create(:road_order, :station_id => station2.id, :contract_id => station2.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "A", :car_type => "Type 1", :start_car => 7, :positions => [ 'A1', 'B1', 'C1', 'D1' ], :day_shifts => day_shifts)
station2_ro3     = FactoryBot.create(:road_order, :station_id => station2.id, :contract_id => station2.contract.id, :author_id => method_engineer1.id, :work_centre => "WC1", :module => "B", :car_type => "Type 2", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)

station3_ro1     = FactoryBot.create(:road_order, :station_id => station3.id, :contract_id => station3.contract.id, :author_id => method_engineer1.id, :work_centre => "WC2", :module => "C", :car_type => "Type 3", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)
station4_ro1     = FactoryBot.create(:road_order, :station_id => station4.id, :contract_id => station4.contract.id, :author_id => method_engineer1.id, :work_centre => "WC2", :module => "C", :car_type => "Type 3", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)

station5_ro1     = FactoryBot.create(:road_order, :station_id => station5.id, :contract_id => station5.contract.id, :author_id => method_engineer2.id, :work_centre => "WC3", :module => "D", :car_type => "Type 4", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)
station6_ro1     = FactoryBot.create(:road_order, :station_id => station6.id, :contract_id => station6.contract.id, :author_id => method_engineer2.id, :work_centre => "WC3", :module => "D", :car_type => "Type 4", :start_car => 1, :positions => [ 'A1', 'B1', 'C1' ], :day_shifts => day_shifts)

# 3 people road orders
[ station1_ro1, station1_ro3, station2_ro3, station3_ro1, station4_ro1, station5_ro1, station6_ro1 ].each_with_index do |ro, i|
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL1", name: "TASK-{i}-111", description: "DESC-{i}-111", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL2", name: "TASK-{i}-112", description: "DESC-{i}-112", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL3", name: "TASK-{i}-113", description: "DESC-{i}-113", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL4", name: "TASK-{i}-114", description: "DESC-{i}-114", expected_duration: 75, breaks: 15, expected_start: "08:00:00", expected_end: "09:30:00", serialized: false, positions: [ "A1", "B1", "C1" ])

  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL1", name: "TASK-{i}-121", description: "DESC-{i}-121", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL2", name: "TASK-{i}-122", description: "DESC-{i}-122", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL3", name: "TASK-{i}-123", description: "DESC-{i}-123", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL4", name: "TASK-{i}-124", description: "DESC-{i}-124", expected_duration: 80, breaks: 15, expected_start: "13:45:00", expected_end: "15:20:00", serialized: false, positions: [ "A1", "B1", "C1" ])

  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL1", name: "TASK-{i}-211", description: "DESC-{i}-211", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL2", name: "TASK-{i}-212", description: "DESC-{i}-212", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL3", name: "TASK-{i}-213", description: "DESC-{i}-213", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL4", name: "TASK-{i}-214", description: "DESC-{i}-214", expected_duration: 90, breaks: 15, expected_start: "08:15:00", expected_end: "10:00:00", serialized: false, positions: [ "A1", "B1", "C1" ])

  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL1", name: "TASK-{i}-221", description: "DESC-{i}-221", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL2", name: "TASK-{i}-222", description: "DESC-{i}-222", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL3", name: "TASK-{i}-223", description: "DESC-{i}-223", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL4", name: "TASK-{i}-224", description: "DESC-{i}-224", expected_duration: 45, breaks: 0,  expected_start: "07:30:00", expected_end: "08:15:00", serialized: false, positions: [ "A1", "B1", "C1" ])
end

# 4 people road orders
[ station1_ro2, station2_ro1, station2_ro2 ].each_with_index do |ro, i|
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL1", name: "TASK-{i}-111", description: "DESC-{i}-111", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL2", name: "TASK-{i}-112", description: "DESC-{i}-112", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL3", name: "TASK-{i}-113", description: "DESC-{i}-113", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL4", name: "TASK-{i}-114", description: "DESC-{i}-114", expected_duration: 60, breaks: 0,  expected_start: "07:00:00", expected_end: "08:00:00", serialized: false, positions: [ "D1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "1", work_location: "WL5", name: "TASK-{i}-115", description: "DESC-{i}-115", expected_duration: 75, breaks: 15, expected_start: "08:00:00", expected_end: "09:30:00", serialized: false, positions: [ "A1", "B1", "C1", "D1" ])

  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL1", name: "TASK-{i}-121", description: "DESC-{i}-121", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL2", name: "TASK-{i}-122", description: "DESC-{i}-122", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL3", name: "TASK-{i}-123", description: "DESC-{i}-123", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL4", name: "TASK-{i}-124", description: "DESC-{i}-124", expected_duration: 45, breaks: 0,  expected_start: "13:00:00", expected_end: "13:45:00", serialized: false, positions: [ "D1" ])
  FactoryBot.create(:definition, road_order: ro, day: "1", shift: "2", work_location: "WL5", name: "TASK-{i}-125", description: "DESC-{i}-125", expected_duration: 80, breaks: 15, expected_start: "13:45:00", expected_end: "15:20:00", serialized: false, positions: [ "A1", "B1", "C1", "D1" ])

  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL1", name: "TASK-{i}-211", description: "DESC-{i}-211", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL2", name: "TASK-{i}-212", description: "DESC-{i}-212", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL3", name: "TASK-{i}-213", description: "DESC-{i}-213", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL4", name: "TASK-{i}-214", description: "DESC-{i}-214", expected_duration: 75, breaks: 0,  expected_start: "07:00:00", expected_end: "08:15:00", serialized: false, positions: [ "D1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "1", work_location: "WL5", name: "TASK-{i}-215", description: "DESC-{i}-215", expected_duration: 90, breaks: 15, expected_start: "08:15:00", expected_end: "10:00:00", serialized: false, positions: [ "A1", "B1", "C1", "D1" ])

  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL1", name: "TASK-{i}-221", description: "DESC-{i}-221", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "A1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL2", name: "TASK-{i}-222", description: "DESC-{i}-222", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "B1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL3", name: "TASK-{i}-223", description: "DESC-{i}-223", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "C1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL4", name: "TASK-{i}-224", description: "DESC-{i}-224", expected_duration: 30, breaks: 0,  expected_start: "07:00:00", expected_end: "07:30:00", serialized: false, positions: [ "D1" ])
  FactoryBot.create(:definition, road_order: ro, day: "2", shift: "2", work_location: "WL5", name: "TASK-{i}-225", description: "DESC-{i}-225", expected_duration: 45, breaks: 0,  expected_start: "07:30:00", expected_end: "08:15:00", serialized: false, positions: [ "A1", "B1", "C1", "D1" ])
end
