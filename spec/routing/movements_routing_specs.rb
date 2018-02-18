require "rails_helper"

RSpec.describe MovementsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/movements/1").to route_to("movements#show", :id => "1")
    end

    it "routes to #update" do
      expect(:put => "/movements/1").to route_to("movements#update", :id => "1")
    end
    
    it "doesn't route to #index" do
      expect(:get => "/movements").to_not route_to("movements#index")
    end
    
    it "doesn't route to #create" do
      expect(:post => "/movements").to_not route_to("movements#create")
    end
    
    it "doesn't route to #destroy" do
      expect(:delete => "/movements/1").to_not route_to("movements#destroy")
    end
  end
end
