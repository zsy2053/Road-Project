require 'rails_helper'

RSpec.describe User, type: :model do
	it { should belong_to(:site) }
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  describe "email attribute" do

  	it "should not be nil" do
  		expect(FactoryBot.build(:user, email: nil)).to_not be_valid
  	end

    it "cannot be blank" do
      expect(FactoryBot.build(:user, email: "")).to_not be_valid
    end
  end
  describe "username attribute" do
  	it "should not be nil" do
  		expect(FactoryBot.build(:user, username: nil)).to_not be_valid
  	end

    it "cannot be blank" do
      expect(FactoryBot.build(:user, username: "")).to_not be_valid
    end
  end

  describe "password attribute" do
    it "cannot be nil" do
      expect(FactoryBot.build(:user, password: nil)).to_not be_valid
    end

    it "cannot be blank" do
      expect(FactoryBot.build(:user, password: "")).to_not be_valid
    end

    it "must have at least one uppercase character" do
    	expect(FactoryBot.build(:user, password: "qwer1234")).to_not be_valid
    end

    it "must have at least one lower character" do
    	expect(FactoryBot.build(:user, password: "QWER1234")).to_not be_valid
    end

    it "must have at least one number" do
    	expect(FactoryBot.build(:user, password: "Qwertyui")).to_not be_valid
    end

    it "must have at least 8 digits" do
    	expect(FactoryBot.build(:user, password: "Qwer123")).to_not be_valid
    end
  end
end
