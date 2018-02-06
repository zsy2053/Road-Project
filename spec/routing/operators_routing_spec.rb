require "rails_helper"

RSpec.describe OperatorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/operators").to route_to("operators#index")
    end


    it "routes to #show" do
      expect(:get => "/operators/1").to route_to("operators#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/operators").to route_to("operators#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/operators/1").to route_to("operators#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/operators/1").to route_to("operators#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/operators/1").to_not route_to("operators#destroy", :id => "1")
    end

    it "routes to #showbadge" do
      expect(:get => "/operators/showbadge/some_id").to route_to("operators#showbadge", :badge => "some_id")
    end

  end
end
