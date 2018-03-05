require "rails_helper"

RSpec.describe StopReasonsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stop_reasons").to route_to("stop_reasons#index")
    end

    it "routes to #show" do
      expect(:get => "/stop_reasons/1").to route_to("stop_reasons#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stop_reasons").not_to route_to("stop_reasons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/stop_reasons/1").not_to route_to("stop_reasons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/stop_reasons/1").not_to route_to("stop_reasons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stop_reasons/1").not_to route_to("stop_reasons#destroy", :id => "1")
    end

  end
end
