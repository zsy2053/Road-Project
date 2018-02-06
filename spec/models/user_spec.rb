require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to(:site) }

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it { should validate_presence_of :first_name }

  it { should validate_presence_of :last_name }

  it { should validate_presence_of :email }
  
  describe :username do
    it "cannot be nil" do
      expect(FactoryBot.build(:user, username: nil)).to_not be_valid
    end

    it "should be unique" do
      user1 = FactoryBot.create(:user, username: "TestUser1234")
      user2 = FactoryBot.build(:user, username: user1.username)
      expect(user2).to_not be_valid
    end
  end

  describe :employee_id do
    it "cannot be nil" do
      expect(FactoryBot.build(:user, employee_id: nil)).to_not be_valid
    end

    it "should be unique" do
      user1 = FactoryBot.create(:user, employee_id: "TestUser1234")
      user2 = FactoryBot.build(:user, employee_id: user1.employee_id)
      expect(user2).to_not be_valid
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

  describe "role attribute" do
    before(:each) do
      @user = FactoryBot.create(:user)
    end
    it "can be assigned to super admin" do
      expect(@user.super_admin?).to be false
      @user.super_admin!
      expect(@user.role).to eq("super_admin")
    end

    it "can be assigned to admin" do
      expect(@user.admin?).to be false
      @user.admin!
      expect(@user.role).to eq("admin")
    end

    it "can be assigned to supervisor" do
      expect(@user.supervisor?).to be false
      @user.supervisor!
      expect(@user.role).to eq("supervisor")
    end

    it "can be assigned to quality" do
      expect(@user.quality?).to be false
      @user.quality!
      expect(@user.role).to eq("quality")
    end

    it "can be assigned to method engineer" do
      expect(@user.method_engineer?).to be false
      @user.method_engineer!
      expect(@user.role).to eq("method_engineer")
    end

    it "can be assigned to planner" do
      expect(@user.planner?).to be false
      @user.planner!
      expect(@user.role).to eq("planner")
    end

    it "can be assigned to station" do
      expect(@user.station?).to be false
      @user.station!
      expect(@user.role).to eq("station")
    end
    
    it "can be assigned to andon" do
      expect(@user.andon?).to be false
      @user.andon!
      expect(@user.role).to eq("andon")
    end

    it "should get a error if wrong value being assigned" do
      expect{ @user.role = "A" }.to raise_error(ArgumentError)
    end
  end

  describe :suspended do
    it "should accept 'true'" do
      expect(FactoryBot.build(:user, :suspended => true)).to be_valid
    end

    it "should accept 'false'" do
      expect(FactoryBot.build(:user, :suspended => false)).to be_valid
    end

    it "should not accept nil" do
      expect(FactoryBot.build(:user, :suspended => nil)).to_not be_valid
    end

    it "should default to false when initialized" do
      expect(User.new().suspended).to eq(false)
    end
  end

  describe :active_for_authentication? do
    it "should return true if suspended attribute is false" do
      user = FactoryBot.build_stubbed(:supervisor_user, suspended: false)
      expect(user.active_for_authentication?).to eq(true)
    end

    it "should return true if suspended attribute is false" do
      user = FactoryBot.build_stubbed(:supervisor_user, suspended: true)
      expect(user.active_for_authentication?).to eq(false)
    end
  end
end
