require "rails_helper"

RSpec.describe AuthenticationController, type: :routing do
  describe "routing" do

    it "routes to #authenticate_user" do
      expect(:post => "/login").to route_to("authentication#authenticate_user")
    end

  end
end
