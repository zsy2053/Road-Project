require "rails_helper"

RSpec.describe TransferOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/transfer_orders").to route_to("transfer_orders#index")
    end

    it "routes to #show" do
      expect(:get => "/transfer_orders/1").to route_to("transfer_orders#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/transfer_orders").to route_to("transfer_orders#create_or_update")
    end

    it "routes to #update via PUT" do
      expect(:put => "/transfer_orders/1").to_not route_to("transfer_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/transfer_orders/1").to_not route_to("transfer_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transfer_orders/1").to_not route_to("transfer_orders#destroy", :id => "1")
    end

  end
end
