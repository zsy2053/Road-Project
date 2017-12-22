require 'rails_helper'

describe AuthenticationController do

  describe "When log in success" do
    let!(:user) { FactoryBot.create(:user, username: "test2", password: "testingA1") }
    subject {post :authenticate_user, params: params}
    let(:params) do
      {
        username: "test2",
        password: "testingA1"
      }
    end

    it "should receive jwt token" do
      #user = FactoryBot.create(:user, email: "test@test.com", password: "testing")
      subject
      expect(response.status).to eq(200)
      expect(response.body.nil?).to eq(false)
    end
  end

  describe "When log in was failed, both username and password are not correct" do
    let!(:user) { FactoryBot.create(:user, username: "test3", password: "testingA2") }
    subject {post :authenticate_user, params: params}
    let(:params) do
      {
        username: "test4",
        password: "testingA3"
      }
    end

    it "should receive error Invalid Username/password" do
      subject
      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"errors\":[\"Invalid Username/Password\"]}")
    end
  end

  describe "When log in was failed, username is correct but password is not correct" do
    let!(:user) { FactoryBot.create(:user, username: "test3", password: "testingA2") }
    subject {post :authenticate_user, params: params}
    let(:params) do
      {
        username: "test3",
        password: "testingA3"
      }
    end

    it "should receive error Invalid Username/password" do
      subject
      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"errors\":[\"Invalid Username/Password\"]}")
    end
  end

  describe "When log in was failed, username is not correct but password is correct" do
    let!(:user) { FactoryBot.create(:user, username: "test3", password: "testingA2") }
    subject {post :authenticate_user, params: params}
    let(:params) do
      {
        username: "test4",
        password: "testingA2"
      }
    end

    it "should receive error Invalid Username/password" do
      subject
      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"errors\":[\"Invalid Username/Password\"]}")
    end
  end
end
