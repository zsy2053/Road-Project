# require 'factory_bot_rails'
# site             = FactoryBot.create(:site)
# contract1        = FactoryBot.create(:contract, :name => "Canada Goose", :site_id => site.id)
# contract2        = FactoryBot.create(:contract, :name => "Arc'teryx", :site_id => site.id)
# station1         = FactoryBot.create(:station, :name => "Queen", :contract_id => contract1.id)
# station2         = FactoryBot.create(:station, :name => "Bloor", :contract_id => contract1.id)
# station3         = FactoryBot.create(:station, :name => "Dundas", :contract_id => contract2.id)
# station4         = FactoryBot.create(:station, :name => "Union", :contract_id => contract2.id)
# supervisor1      = FactoryBot.create(:supervisor_user, :site_id => site.id, :username => "supervisor1")
# super_admin1     = FactoryBot.create(:super_admin_user, :site_id => site.id, :username => "super_admin1")
# admin1           = FactoryBot.create(:admin_user, :site_id => site.id, :username => "admin1")
# method_engineer1 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :username => "method_engineer1")
# method_engineer2 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :username => "method_engineer2")
# planner1         = FactoryBot.create(:planner_user, :site_id => site.id, :username => "planner1")
# qa1              = FactoryBot.create(:quality_user, :site_id => site.id, :username => "qa1")
# station_user1    = FactoryBot.create(:station_user, :site_id => site.id, :username => "station_user1")

# access1          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract1.id)
# access2          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract2.id)
# access3          = FactoryBot.create(:access, :user_id => method_engineer2.id, :contract_id => contract1.id)

# (1..9).each do |i|
# 	FactoryBot.create(:road_order, :car_type => "Ferrari_#{i}", :start_car => 1, :station_id => station1.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Porsche_#{i}", :start_car => 2, :station_id => station1.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Rolls-Royce_#{i} ", :start_car => 3, :station_id => station2.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Lamborghini_#{i}", :start_car => 4, :station_id => station2.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Aston Martin_#{i}", :start_car => 5, :station_id => station3.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Tesla_#{i}", :start_car => 6, :station_id => station3.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Bentley_#{i}", :start_car => 7, :station_id => station4.id, :author_id => method_engineer1.id)
# 	FactoryBot.create(:road_order, :car_type => "Maserati_#{i}", :start_car => 8, :station_id => station4.id, :author_id => method_engineer1.id)
# end

