require "rails_helper"

RSpec.describe DeviseController, type: :routing do
  describe "routing" do

    it "routes to sessions#new" do
      expect(:get => "/users/sign_in").to route_to("devise/sessions#new")
    end
    
    it "routes to sessions#create" do
      expect(:post => "/users/sign_in").to route_to("devise/sessions#create")
    end
    
    it "routes to sessions#destroy" do
      expect(:delete => "/users/sign_out").to route_to("devise/sessions#destroy")
    end
    
    it "routes to passwords#new" do
      expect(:get => "/users/password/new").to route_to("devise/passwords#new")
    end
    
    it "routes to passwords#edit" do
      expect(:get => "/users/password/edit").to route_to("devise/passwords#edit")
    end
    
    it "routes to passwords#update via PUT" do
      expect(:put => "/users/password").to route_to("devise/passwords#update")
    end
    
    it "routes to passwords#update via PUT" do
      expect(:patch => "/users/password").to route_to("devise/passwords#update")
    end
    
    it "routes to passwords#create" do
      expect(:post => "/users/password").to route_to("devise/passwords#create")
    end
    
  end
end
