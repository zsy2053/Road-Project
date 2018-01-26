require "rails_helper"

RSpec.describe AccessesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/accesses").to_not route_to("accesses#index")
    end

    it "routes to #show" do
      expect(:get => "/accesses/1").to_not route_to("accesses#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/accesses").to route_to("accesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/accesses/1").to_not route_to("accesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/accesses/1").to_not route_to("accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/accesses/1").to route_to("accesses#destroy", :id => "1")
    end

    it "routes to #multi_update" do
      expect(:post => "/accesses/multi_update").to route_to("accesses#multi_update")
    end

  end
end
