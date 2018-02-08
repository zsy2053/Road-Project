require "rails_helper"

RSpec.describe CarRoadOrdersController, type: :routing do
  describe "routing" do
    
    it "routes to #index" do
      expect(:get => "/car_road_orders").to route_to("car_road_orders#index")
    end
    
    it "routes to #show" do
      expect(:get => "/car_road_orders/1").to route_to("car_road_orders#show", :id => "1")
    end
    
    it "routes to #create" do
      expect(:post => "/car_road_orders").to route_to("car_road_orders#create")
    end
    
    it "routes to #update via PUT" do
      expect(:put => "/car_road_orders/1").to_not route_to("car_road_orders#update", :id => "1")
    end
    
    it "routes to #update via PATCH" do
      expect(:patch => "/car_road_orders/1").to_not route_to("car_road_orders#update", :id => "1")
    end
    
    it "routes to #destroy" do
      expect(:delete => "/car_road_orders/1").to_not route_to("car_road_orders#destroy", :id => "1")
    end
    
  end
end
