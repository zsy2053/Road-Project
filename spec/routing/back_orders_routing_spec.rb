require "rails_helper"

RSpec.describe BackOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/back_orders").to route_to("back_orders#index")
    end

    it "routes to #show" do
      expect(:get => "/back_orders/1").to route_to("back_orders#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/back_orders").to route_to("back_orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/back_orders/1").to_not route_to("back_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/back_orders/1").to_not route_to("back_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/back_orders/1").to_not route_to("back_orders#destroy", :id => "1")
    end

  end
end
