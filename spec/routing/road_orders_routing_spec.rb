require "rails_helper"

RSpec.describe RoadOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/road_orders").to route_to("road_orders#index")
    end

  end
end
