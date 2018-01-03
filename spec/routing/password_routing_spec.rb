require "rails_helper"

RSpec.describe PasswordsController, type: :routing do
  describe "routing" do

    it "routes to #forgot" do
      expect(:post => "/password/forgot").to route_to("passwords#forgot")
    end

    it "routes to #reset" do
      expect(:post => "/password/reset").to route_to("passwords#reset")
    end

  end
end
