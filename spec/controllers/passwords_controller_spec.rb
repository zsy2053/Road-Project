require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  describe "forgot password" do
    let(:email) { "shuyang.zang@robinsonsolutions.com" }
    let!(:user) { FactoryBot.create(:user, username: "test3", password: "testingB2", email: email) }
    subject {post :forgot, params: params}
    let(:params) do
      {
        email:email
      }
    end
    
    before(:each) do
      expect(user.reset_password_token).to be_nil
      expect(user.reset_password_sent_at).to be_nil
    end

    it "should succeed" do
      subject
      expect(response.status).to eq(200)
    end
    
    it "should have a reset token" do
      subject
      user.reload
      expect(user.reset_password_token).to_not be_nil
    end
    
    it "should have a sent date" do
      subject
      user.reload
      expect(user.reset_password_sent_at).to_not be_nil
    end
    
    describe "email" do
      it "should be sent" do
        expect { subject }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
      
      it 'should contain a link to the reset URL' do
        subject
        user.reload
        msg = ActionMailer::Base.deliveries.last
        expect(msg.body.raw_source).to include("#{ENV['WEB_APP_URL']}/newpassword/#{user.reset_password_token}")
      end
    end
  end
  
  describe "reset password" do
    let(:email) { "shuyang.zang@robinsonsolutions.com" }
    let(:old_password) { "testingB2" }
    let(:new_password) {"new" + old_password }
    let(:reset_token) { "sometoken123" }
    let(:user) { FactoryBot.create(:user, username: "test3", password: old_password, email: email, reset_password_token: reset_token, reset_password_sent_at: reset_time) }
    
    let(:params) do
      {
        token: reset_token,
        email: email,
        password: new_password
      }
    end
      
    before(:each) do
      expect(new_password).not_to eq(old_password)
      expect(user.valid?).to be_truthy
    end
    
    subject { post :reset, params: params }
    
    describe "when token does not exist" do
      let(:reset_time) { Time.now.utc }
      
      let(:fake_token) { "not-a-token" }
      let(:params) do
        {
          token: fake_token,
          email: email,
          password: new_password
        }
      end
      
      before(:each) do
        expect(fake_token).to_not eq(reset_token)
      end
      
      it "should report unprocessable" do
        subject
        expect(response.status).to eq(422)
      end
      
      it "should not change the password" do
        subject
        user.reload
        expect(user.valid_password?(old_password)).to be_truthy
      end
    end
    
    describe "when it's not expired" do
      let(:reset_time) { Time.now.utc }
      
      it "should succeed" do
        subject
        expect(response.status).to eq(200)
      end
      
      it "should change the password" do
        subject
        user.reload
        expect(user.valid_password?(new_password)).to be_truthy
      end
    end

    describe "when it's expired" do
      let(:reset_time) { Time.now.utc - 5.hours }
  
      it "should not be processable" do
        subject
        expect(response.status).to eq(422)
      end
      
      it "should not change the password" do
        subject
        user.reload
        expect(user.valid_password?(old_password)).to be_truthy
      end
    end
  end
end
