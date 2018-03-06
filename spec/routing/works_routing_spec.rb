require "rails_helper"

RSpec.describe WorksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/works").to route_to("works#index")
    end

    it "routes to #show" do
      expect(:get => "/works/1").to route_to("works#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/works").to route_to("works#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/works/1").not_to route_to("works#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/works/1").not_to route_to("works#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/works/1").not_to route_to("works#destroy", :id => "1")
    end

  end
end
