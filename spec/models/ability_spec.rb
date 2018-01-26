require 'rails_helper'
require "cancan/matchers"

RSpec.shared_examples "a user who can manage uploads" do |role|
  let(:this_user) { FactoryBot.build_stubbed(:user, role: role) }
  let(:ability) { Ability.new(this_user) }
  let(:upload) { FactoryBot.build_stubbed(:upload, user: this_user) }
  
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:other_upload) { FactoryBot.build_stubbed(:upload, user: other_user) }
  
  it "can create new uploads" do
    expect(ability).to be_able_to(:create, Upload)
  end
  
  it "can read own uploads" do
    expect(ability).to be_able_to(:read, upload)
  end
  
  it "cannot read someone else's upload" do
    expect(ability).to_not be_able_to(:read, other_upload)
  end
  
  it "can update own uploads" do
    expect(ability).to be_able_to(:update, upload)
  end
  
  it "cannot update someone else's upload" do
    expect(ability).to_not be_able_to(:update, other_upload)
  end
  
  it "can delete own uploads" do
    expect(ability).to be_able_to(:delete, upload)
  end
  
  it "cannot delete someone else's upload" do
    expect(ability).to_not be_able_to(:delete, other_upload)
  end
end

RSpec.shared_examples "a user who can create but not modify road orders for their contracts" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:other_contract) { FactoryBot.create(:contract) }
  
  # road order objects use 'build' so the are not considered to be persisted
  let(:road_order) { FactoryBot.build(:road_order, contract: contract, station: FactoryBot.build_stubbed(:station, contract: contract)) }
  let(:other_road_order) { FactoryBot.build(:road_order, contract: other_contract, station: FactoryBot.build_stubbed(:station, contract: other_contract)) }
  
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  
  let(:ability) { Ability.new(this_user) }
  
  it "cannot create a road order for an inaccessible contract" do
    expect(ability).to be_able_to(:create, RoadOrder)
    expect(other_road_order).to_not be_persisted
    expect(ability).to_not be_able_to(:create, other_road_order)
  end
  
  it "can create a road order for an accessible contract" do
    expect(ability).to be_able_to(:create, RoadOrder)
    expect(road_order).to_not be_persisted
    expect(ability).to be_able_to(:create, road_order)
  end
  
  it "cannot update a road order" do
    expect(ability).to_not be_able_to(:update, RoadOrder)
  end
  
  it "cannot delete a road order" do
    expect(ability).to_not be_able_to(:delete, RoadOrder)
  end
end

RSpec.shared_examples "a user who can only read their road orders" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:other_contract) { FactoryBot.create(:contract) }

  let(:road_order) { FactoryBot.build_stubbed(:road_order, contract: contract, station: FactoryBot.build_stubbed(:station, contract: contract)) }
  let(:other_road_order) { FactoryBot.build_stubbed(:road_order, contract: other_contract, station: FactoryBot.build_stubbed(:station, contract: other_contract)) }
  
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  
  let(:ability) { Ability.new(this_user) }
  
  it "can read road orders for an accessible contract" do
    expect(ability).to be_able_to(:read, road_order)
  end
  
  it "cannot read road orders for an inaccessible contract" do
    expect(ability).to_not be_able_to(:read, other_road_order)
  end
end

RSpec.shared_examples "a user who can read all road orders" do |role|
  let!(:this_user) { FactoryBot.build_stubbed(:user, role: role) }
  let!(:ability) { Ability.new(this_user) }
  let!(:road_order) { FactoryBot.build_stubbed(:road_order) }
  let!(:other_road_order) { FactoryBot.build_stubbed(:road_order) }
  
  before(:each) do
    expect(this_user.accesses).to be_empty
  end
  
  it "can read road orders for an inaccessible contract" do
    expect(ability).to be_able_to(:read, road_order)
    expect(ability).to be_able_to(:read, other_road_order)
  end
end

RSpec.shared_examples "a user who cannot modify road orders" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  let!(:ability) { Ability.new(this_user) }
  
  it "cannot create a new road order" do
    expect(ability).to_not be_able_to(:create, RoadOrder)
  end
  
  it "cannot update a road order" do
    expect(ability).to_not be_able_to(:update, RoadOrder)
  end
  
  it "cannot delete a road order" do
    expect(ability).to_not be_able_to(:delete, RoadOrder)
  end
end

RSpec.shared_examples "a user who can manage all sites" do |role|
  it "can manage sites" do
    ability = Ability.new(FactoryBot.create(:user, role: role))
    expect(ability).to be_able_to(:manage, Site)
  end
end

RSpec.shared_examples "a user who can only read their own site" do |role|
  let!(:site) { FactoryBot.create(:site) }
  let!(:other_site) { FactoryBot.create(:site) }
  let!(:this_user) { FactoryBot.create(:user, site: site, role: role) }
  let!(:ability) { Ability.new(this_user) }
  
  it "can read their site" do
    expect(ability).to be_able_to(:read, site)
  end
  
  it "cannot read other sites" do
    expect(ability).to_not be_able_to(:read, other_site)
  end
  
  it "cannot create sites" do
    expect(ability).to_not be_able_to(:create, Site)
  end
  
  it "cannot update sites" do
    expect(ability).to_not be_able_to(:update, Site)
  end
  
  it "cannot destroy sites" do
    expect(ability).to_not be_able_to(:destroy, Site)
  end
end

RSpec.shared_examples "a user who can only read their back orders" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:other_contract) { FactoryBot.create(:contract) }

  let(:back_order) { FactoryBot.build_stubbed(:back_order, contract: contract, station: FactoryBot.build_stubbed(:station, contract: contract)) }
  let(:other_back_order) { FactoryBot.build_stubbed(:back_order, contract: other_contract, station: FactoryBot.build_stubbed(:station, contract: other_contract)) }
  
  
  let!(:back_orders) { [FactoryBot.create(:back_order, contract: other_contract, station: stations[0]),
                     FactoryBot.create(:back_order, contract: other_contract, station: stations[1])] }
                     
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  
  let(:ability) { Ability.new(this_user) }
  
  it "can read back orders for an accessible contract" do
    expect(ability).to be_able_to(:read, back_order)
  end
  
  it "cannot read back orders for an inaccessible contract" do
    expect(ability).to_not be_able_to(:read, other_back_order)
  end
end

RSpec.shared_examples "a user who can read all back orders" do |role|
  let!(:this_user) { FactoryBot.build_stubbed(:user, role: role) }
  let!(:ability) { Ability.new(this_user) }
  let!(:back_order) { FactoryBot.build_stubbed(:back_order) }
  let!(:other_back_order) { FactoryBot.build_stubbed(:back_order) }
  
  before(:each) do
    expect(this_user.accesses).to be_empty
  end
  
  it "can read back orders for an inaccessible contract" do
    expect(ability).to be_able_to(:read, back_order)
    expect(ability).to be_able_to(:read, other_back_order)
  end
end

RSpec.shared_examples "a user who cannot modify back orders" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  let!(:ability) { Ability.new(this_user) }
  
  it "cannot create a new back order" do
    expect(ability).to_not be_able_to(:create, BackOrder)
  end
  
  it "cannot update a back order" do
    expect(ability).to_not be_able_to(:update, BackOrder)
  end
  
  it "cannot delete a back order" do
    expect(ability).to_not be_able_to(:delete, BackOrder)
  end
end

RSpec.shared_examples "a user who can create but not modify back orders for their contracts" do |role|
  let!(:contract) { FactoryBot.create(:contract) }
  let!(:other_contract) { FactoryBot.create(:contract) }
  
  # road order objects use 'build' so the are not considered to be persisted
  let(:road_order) { FactoryBot.build(:road_order, contract: contract, station: FactoryBot.build_stubbed(:station, contract: contract)) }
  let(:other_road_order) { FactoryBot.build(:road_order, contract: other_contract, station: FactoryBot.build_stubbed(:station, contract: other_contract)) }
  
  let!(:back_order) { FactoryBot.build(:back_order, contract: contract, station: FactoryBot.build_stubbed(:station, contract: contract)) }
  let!(:other_back_order) { FactoryBot.build(:back_order, contract: other_contract, station: FactoryBot.build_stubbed(:station, contract: other_contract)) }
                     
  let!(:this_user) { FactoryBot.create(:user, role: role) }
  let!(:access) { FactoryBot.create(:access, user: this_user, contract: contract) }
  
  let(:ability) { Ability.new(this_user) }
  
  it "cannot create a back order for an inaccessible contract" do
    expect(ability).to be_able_to(:create, BackOrder)
    expect(other_back_order).to_not be_persisted
    expect(ability).to_not be_able_to(:create, other_road_order)
  end
  
  it "can create a back order for an accessible contract" do
    expect(ability).to be_able_to(:create, BackOrder)
    expect(back_order).to_not be_persisted
    expect(ability).to be_able_to(:create, back_order)
  end
  
  it "cannot update a back order" do
    expect(ability).to_not be_able_to(:update, BackOrder)
  end
  
  it "cannot delete a back order" do
    expect(ability).to_not be_able_to(:delete, BackOrder)
  end
end

describe "Ability" do

  let!(:sites) {[ FactoryBot.create(:site), FactoryBot.create(:site) ]}
  let!(:user) { FactoryBot.create(:user, site: sites[0]) }
  let!(:users) {[ FactoryBot.create(:user, site: sites[0], role: "station"), FactoryBot.create(:user, site: sites[1], role: "station") ]}
  let!(:super_admin) {FactoryBot.create(:super_admin_user, site: sites[0])}
  let!(:contracts) {[ FactoryBot.create(:contract, site: sites[0], status: "open"),
                      FactoryBot.create(:contract, site: sites[1], status: "open") ]}
  let!(:accesses) {[ FactoryBot.create(:access, user: users[0], contract: contracts[0]),
                     FactoryBot.create(:access, user: users[1], contract: contracts[1]),
                     FactoryBot.create(:access, user: super_admin, contract: contracts[0]) ]}
  let!(:stations) {[ FactoryBot.create(:station, contract: contracts[0]),
                     FactoryBot.create(:station, contract: contracts[1]) ]}
  let!(:road_orders) { [FactoryBot.create(:road_order, station: stations[0]),
                     FactoryBot.create(:road_order, station: stations[1])] }


  describe "supervisor" do

    before(:each) do
      user.supervisor!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow supervisors to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow supervisors to see the sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow supervisors to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow supervisors to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow supervisors to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow supervisors to see the stations for other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should only allow supervisors to see users(except super_admin) which have at least one same contract" do
      can_only_see_users_belong_to_same_contract(user)
    end

    it_should_behave_like "a user who can only read their own site", "supervisor"
    
    it_should_behave_like "a user who can manage uploads", "supervisor"
    
    it_should_behave_like "a user who can only read their road orders", "supervisor"
    it_should_behave_like "a user who cannot modify road orders", "supervisor"
    
    it_should_behave_like "a user who can only read their back orders", "supervisor"
    it_should_behave_like "a user who cannot modify back orders", "supervisor"    
  end

  describe "planner" do

    before(:each) do
      user.planner!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow planners to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow planners to see sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow planners to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow planners to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow planners to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow planners to see the stations for other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should only allow planners to see users(except super_admin) which have at least one same contract" do
      can_only_see_users_belong_to_same_contract(user)
    end

    it_should_behave_like "a user who can only read their own site", "planner"
    
    it_should_behave_like "a user who can manage uploads", "planner"
    
    it_should_behave_like "a user who can only read their road orders", "planner"
    it_should_behave_like "a user who cannot modify road orders", "planner"
    
    it_should_behave_like "a user who can only read their back orders", "planner"
    it_should_behave_like "a user who can create but not modify back orders for their contracts", "planner"
  end

  describe "method_engineer" do

    before(:each) do
      user.method_engineer!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow method_engineers to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow method_engineers to see the sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow method_engineers to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow method_engineers to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow method_engineers to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow method_engineers to see the station sfor other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should only allow method_engineers to see users(except super_admin) which have at least one same contract" do
      can_only_see_users_belong_to_same_contract(user)
    end
    
    it_should_behave_like "a user who can only read their own site", "method_engineer"
    
    it_should_behave_like "a user who can manage uploads", "method_engineer"
    
    it_should_behave_like "a user who can only read their road orders", "method_engineer"
    it_should_behave_like "a user who can create but not modify road orders for their contracts", "method_engineer"
    
    it_should_behave_like "a user who can only read their back orders", "method_engineer"
    it_should_behave_like "a user who cannot modify back orders", "method_engineer"    
  end

  describe "quality" do

    before(:each) do
      user.quality!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow qualitys to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow qualitys to see the sites they do not belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should allow qualitys to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow qualitys to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow qualitys to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow qualitys to see the stations for other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should only allow qualitys to see users(except super_admin) which have at least one same contract" do
      can_only_see_users_belong_to_same_contract(user)
    end
    
    it_should_behave_like "a user who can only read their own site", "quality"
    
    it_should_behave_like "a user who can manage uploads", "quality"
    
    it_should_behave_like "a user who can only read their road orders", "quality"
    it_should_behave_like "a user who cannot modify road orders", "quality"
    
    it_should_behave_like "a user who can only read their back orders", "quality"
    it_should_behave_like "a user who cannot modify back orders", "quality"    
  end

  describe "station" do

    before(:each) do
      user.station!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow station users to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow station users to see the sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow station users to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow station users to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow station users to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow station users to see the stations for other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should only allow station users to see users(except super_admin) which have at least one same contract" do
      can_only_see_users_belong_to_same_contract(user)
    end
    
    it_should_behave_like "a user who can only read their own site", "station"
    
    it_should_behave_like "a user who can manage uploads", "station"
    
    it_should_behave_like "a user who can only read their road orders", "station"
    it_should_behave_like "a user who cannot modify road orders", "station"
    
    it_should_behave_like "a user who can only read their back orders", "station"
    it_should_behave_like "a user who cannot modify back orders", "station"    
  end

  describe "admin" do

    before(:each) do
      user.admin!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow admins to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow admins to see the sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow admins to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow admins to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow admins to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow admins to see the stations for other contract" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should not allow admins to see super admin users in their sites" do
      super_admin = FactoryBot.create(:user, site: sites[0], role: 'super_admin')
      ability = Ability.new(user)

      expect(ability).not_to be_able_to(:manage, super_admin)
    end

    it "should not allow admins to see super admin users in other sites" do
      super_admin = FactoryBot.create(:user, site: sites[1], role: 'super_admin')
      ability = Ability.new(user)

      expect(ability).not_to be_able_to(:manage, super_admin)
    end

    it "should allow admins to manage users in their sites" do
      supervisor = FactoryBot.create(:user, site: sites[0], role: 'supervisor')
      quality = FactoryBot.create(:user, site: sites[0], role: 'quality')
      method_engineer = FactoryBot.create(:user, site: sites[0], role: 'method_engineer')
      planner = FactoryBot.create(:user, site: sites[0], role: 'planner')
      admin = FactoryBot.create(:user, site: sites[0], role: 'admin')
      station = FactoryBot.create(:user, site: sites[0], role: 'station')
      users[1].role = 'supervisor'
      ability = Ability.new(user)

      expect(ability).to be_able_to(:manage, supervisor)
      expect(ability).to be_able_to(:manage, quality)
      expect(ability).to be_able_to(:manage, method_engineer)
      expect(ability).to be_able_to(:manage, admin)
      expect(ability).to be_able_to(:manage, planner)
      expect(ability).to be_able_to(:manage, station)
      expect(ability).not_to be_able_to(:manage, users[1])
    end

    it "should allow admins to manage accesses in their sites who are not super admins" do
      #super_admin = FactoryBot.create(:user, site: sites[0], role: 'super_admin')
      users[0].role = 'supervisor'
      ability = Ability.new(user)

      expect(ability).to be_able_to(:manage, accesses[0])
      expect(ability).not_to be_able_to(:manage, accesses[1])
    end
    
    it_should_behave_like "a user who can only read their own site", "admin"
    
    it_should_behave_like "a user who can manage uploads", "admin"
    
    it_should_behave_like "a user who can only read their road orders", "admin"
    it_should_behave_like "a user who cannot modify road orders", "admin"
    
    it_should_behave_like "a user who can only read their back orders", "admin"
    it_should_behave_like "a user who cannot modify back orders", "admin"    
  end

  describe "super_admin" do

    before(:each) do
      user.super_admin!
    end

    it "should allow super admins to manage everything except road order" do
      ability = Ability.new(user)

      expect(ability).to be_able_to(:manage, users[0])
      expect(ability).to be_able_to(:manage, users[1])
      expect(ability).to be_able_to(:manage, accesses[0])
      expect(ability).to be_able_to(:manage, accesses[1])
      expect(ability).to be_able_to(:manage, stations[0])
      expect(ability).to be_able_to(:manage, stations[1])
      expect(ability).to be_able_to(:manage, contracts[0])
      expect(ability).to be_able_to(:manage, contracts[1])
      expect(ability).to be_able_to(:manage, sites[0])
      expect(ability).to be_able_to(:manage, sites[1])
    end
    
    it_should_behave_like  "a user who can manage all sites", "super_admin"
    
    it_should_behave_like "a user who can manage uploads", "super_admin"
    
    it_should_behave_like "a user who can manage uploads", "super_admin"
    
    it_should_behave_like "a user who can read all road orders", "super_admin"
    it_should_behave_like "a user who cannot modify road orders", "super_admin"
    
    it_should_behave_like "a user who can read all road orders", "super_admin"
    it_should_behave_like "a user who cannot modify back orders", "super_admin"    
  end

  def can_read_the_site_they_belong_to(user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:read, sites[0])
    expect(ability).not_to be_able_to(:create, sites[0])
    expect(ability).not_to be_able_to(:update, sites[0])
    expect(ability).not_to be_able_to(:delete, sites[0])
  end

  def cannot_read_the_sites_they_do_not_belong_to(user)
    ability = Ability.new(user)

    expect(ability).not_to be_able_to(:read, sites[1])
    expect(ability).not_to be_able_to(:create, sites[1])
    expect(ability).not_to be_able_to(:update, sites[1])
    expect(ability).not_to be_able_to(:delete, sites[1])
  end

  def can_read_the_contracts_they_belong_to(user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:read, contracts[0])
    expect(ability).not_to be_able_to(:create, contracts[0])
    expect(ability).not_to be_able_to(:update, contracts[0])
    expect(ability).not_to be_able_to(:delete, contracts[0])
  end

  def cannot_read_the_contracts_they_do_not_belong_to(user)
    ability = Ability.new(user)

    expect(ability).not_to be_able_to(:read, contracts[1])
    expect(ability).not_to be_able_to(:create, contracts[1])
    expect(ability).not_to be_able_to(:update, contracts[1])
    expect(ability).not_to be_able_to(:delete, contracts[1])
  end

  def can_see_the_stations_for_the_contract_they_belong_to(user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:read, stations[0])
    expect(ability).not_to be_able_to(:create, stations[0])
    expect(ability).not_to be_able_to(:update, stations[0])
    expect(ability).not_to be_able_to(:delete, stations[0])
  end

  def cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    ability = Ability.new(user)

    expect(ability).not_to be_able_to(:read, stations[1])
    expect(ability).not_to be_able_to(:create, stations[1])
    expect(ability).not_to be_able_to(:update, stations[1])
    expect(ability).not_to be_able_to(:delete, stations[1])
  end

  def can_only_see_users_belong_to_same_contract(user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:read, users[0])
    expect(ability).not_to be_able_to(:create, users[0])
    expect(ability).not_to be_able_to(:update, users[0])
    expect(ability).not_to be_able_to(:delete, users[0])
    expect(ability).not_to be_able_to(:read, users[1])
    expect(ability).not_to be_able_to(:create, users[1])
    expect(ability).not_to be_able_to(:update, users[1])
    expect(ability).not_to be_able_to(:delete, users[1])
    expect(ability).not_to be_able_to(:read, super_admin)
  end
end