require "rails_helper"

RSpec.describe RoadOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/road_orders").to route_to("road_orders#index")
    end

    it "routes to #show" do
      expect(:get => "/road_orders/1").to route_to("road_orders#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/road_orders").to route_to("road_orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/road_orders/1").not_to route_to("road_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/road_orders/1").not_to route_to("road_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/road_orders/1").not_to route_to("road_orders#destroy", :id => "1")
    end

  end
end
