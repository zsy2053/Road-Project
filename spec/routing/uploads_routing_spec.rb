require "rails_helper"

RSpec.describe UploadsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/uploads").not_to route_to("uploads#index")
    end

    it "routes to #show" do
      expect(:get => "/uploads/1").to route_to("uploads#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/uploads").to route_to("uploads#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/uploads/1").not_to route_to("uploads#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/uploads/1").not_to route_to("uploads#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/uploads/1").not_to route_to("uploads#destroy", :id => "1")
    end

  end
end
