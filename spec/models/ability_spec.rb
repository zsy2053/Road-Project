require 'rails_helper'
require "cancan/matchers"

describe "Ability" do

  let!(:sites) {[ FactoryBot.create(:site), FactoryBot.create(:site) ]}
  let!(:user) { FactoryBot.create(:user, site: sites[0]) }
  let!(:users) {[ FactoryBot.create(:user, site: sites[0]), FactoryBot.create(:user, site: sites[1]) ]}
  let!(:contracts) {[ FactoryBot.create(:contract, site: sites[0], status: "open"),
                      FactoryBot.create(:contract, site: sites[1], status: "open") ]}
  let!(:accesses) {[ FactoryBot.create(:access, user: users[0], contract: contracts[0]),
                     FactoryBot.create(:access, user: users[1], contract: contracts[1]) ]}
  let!(:stations) {[ FactoryBot.create(:station, contract: contracts[0]),
                     FactoryBot.create(:station, contract: contracts[1]) ]}

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

    it "should not allow supervisors to see users" do
      cannot_see_users(user)
    end
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

    it "should not allow planners to see users" do
      cannot_see_users(user)
    end
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

    it "should not allow method_engineers to see users" do
      cannot_see_users(user)
    end
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

    it "should not allow qualitys to see users" do
      cannot_see_users(user)
    end
  end

  describe "station" do

    before(:each) do
      user.station!
      FactoryBot.create(:access, user:user, contract: contracts[0])
    end

    it "should allow stations to see the site they belong to" do
      can_read_the_site_they_belong_to(user)
    end

    it "should not allow stations to see the sites they do not belong to" do
      cannot_read_the_sites_they_do_not_belong_to(user)
    end

    it "should allow stations to see the contracts they belong to" do
     can_read_the_contracts_they_belong_to(user)
    end

    it "should not allow stations to see the contracts they do not belong to" do
     cannot_read_the_contracts_they_do_not_belong_to(user)
    end

    it "should allow stations to see the station for their contract" do
      can_see_the_stations_for_the_contract_they_belong_to(user)
    end

    it "should not allow stations to see the stations for other contracts" do
      cannot_see_the_stations_for_the_contract_they_do_not_belong_to(user)
    end

    it "should not allow stations to see users" do
      cannot_see_users(user)
    end
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
      super_admin = FactoryBot.create(:user, site: sites[0], role: 'super_admin')
      ability = Ability.new(user)

      expect(ability).to be_able_to(:manage, users[0])
      expect(ability).not_to be_able_to(:manage, users[1])
    end

    it "should allow admins to manage accesses in their sites who are not super admins" do
      super_admin = FactoryBot.create(:user, site: sites[0], role: 'super_admin')
      ability = Ability.new(user)

      expect(ability).to be_able_to(:manage, accesses[0])
      expect(ability).not_to be_able_to(:manage, accesses[1])
    end
  end

  describe "super_admin" do

    before(:each) do
      user.super_admin!
    end

    it "should allow super admins to manage everything" do
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

  def cannot_see_users(user)
    ability = Ability.new(user)

    expect(ability).not_to be_able_to(:read, users[0])
    expect(ability).not_to be_able_to(:create, users[0])
    expect(ability).not_to be_able_to(:update, users[0])
    expect(ability).not_to be_able_to(:delete, users[0])
    expect(ability).not_to be_able_to(:read, users[1])
    expect(ability).not_to be_able_to(:create, users[1])
    expect(ability).not_to be_able_to(:update, users[1])
    expect(ability).not_to be_able_to(:delete, users[1])
  end
end