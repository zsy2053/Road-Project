require 'factory_bot_rails'
site             = FactoryBot.create(:site, name: "Toronto", number: "CA99", address_line_1: "390 Bay Street", address_line_2: "Suite 1520", city: "Toronto", province: "Ontario", post_code: "M5H 2Y2", country: "Canada", time_zone: "America/New_York")

contract1        = FactoryBot.create(:contract, :name => "Edmonton", :code => "C0260", :description => "Edmonton", :site_id => site.id, :minimum_offset => 2)
contract2        = FactoryBot.create(:contract, :name => "TTC", :code => "C0248", :description => "Toronto Transit Commission", :site_id => site.id, :minimum_offset => 2)
contract3        = FactoryBot.create(:contract, :name => "Metrolinx", :code => "C0263", :description => "Metrolinx", :site_id => site.id, :minimum_offset => 2)

station1         = FactoryBot.create(:station, :name => "Station 1", :code => "SA10", :contract_id => contract1.id)
station2         = FactoryBot.create(:station, :name => "Station 2", :code => "SA20", :contract_id => contract1.id)
station3         = FactoryBot.create(:station, :name => "Station 1", :code => "SB11", :contract_id => contract2.id)
station4         = FactoryBot.create(:station, :name => "Station 2", :code => "SB21", :contract_id => contract2.id)
station5         = FactoryBot.create(:station, :name => "Station 1", :code => "SC12", :contract_id => contract3.id)
station6         = FactoryBot.create(:station, :name => "Station 2", :code => "SC22", :contract_id => contract3.id)

supervisor1      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Alex", :last_name => "Anderson", :employee_id => "20933", :username => "supervisor.alex", :email => "alex.anderson@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
supervisor2      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Heidi", :last_name => "Harris", :employee_id => "20913", :username => "supervisor.heidi", :email => "heidi.harris@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
supervisor3      = FactoryBot.create(:supervisor_user, :site_id => site.id, :first_name => "Idriss", :last_name => "Ion", :employee_id => "83822", :username => "supervisor.idriss", :email => "idriss.ion@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

super_admin1     = FactoryBot.create(:super_admin_user, :site_id => site.id, :first_name => "Bill", :last_name => "Brooks", :employee_id => "39394", :username => "superadmin.bill", :email => "bill.brooks@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

admin1           = FactoryBot.create(:admin_user, :site_id => site.id, :first_name => "Cindy", :last_name => "Clark", :employee_id => "88454", :username => "admin.cindy", :email => "cindy.clark@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

method_engineer1 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :first_name => "Debbie", :last_name => "Donalds", :employee_id => "48483", :username => "me.debbie", :email => "debbie.donalds@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
method_engineer2 = FactoryBot.create(:method_engineer_user, :site_id => site.id, :first_name => "Florence", :last_name => "Fawks", :employee_id => "84443", :username => "me.florence", :email => "florence.fawks@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

planner1         = FactoryBot.create(:planner_user, :site_id => site.id, :first_name => "Eric", :last_name => "Earl", :employee_id => "31223", :username => "planner.eric", :email => "eric.earl@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
qa1              = FactoryBot.create(:quality_user, :site_id => site.id, :first_name => "Greg", :last_name => "Gagner", :employee_id => "23234", :username => "qa.greg", :email => "greg.gagner@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")
#station_user1    = FactoryBot.create(:station_user, :site_id => site.id, :first_name => "Zelda", :last_name => "Zane", :employee_id => "12354", :username => "genericstation", :email => "ero-generic-station@bombardier", :password => "Passwd123", :password_confirmation => "Passwd123")

access1          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract1.id)
access2          = FactoryBot.create(:access, :user_id => method_engineer1.id, :contract_id => contract2.id)
access3          = FactoryBot.create(:access, :user_id => method_engineer2.id, :contract_id => contract1.id)
access4          = FactoryBot.create(:access, :user_id => method_engineer2.id, :contract_id => contract3.id)

access5          = FactoryBot.create(:access, :user_id => supervisor1.id, :contract_id => contract1.id)
access6          = FactoryBot.create(:access, :user_id => supervisor2.id, :contract_id => contract2.id)
access7          = FactoryBot.create(:access, :user_id => supervisor2.id, :contract_id => contract3.id)