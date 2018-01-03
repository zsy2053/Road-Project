require 'rails_helper'

RSpec.describe "Stations", type: :request do
  describe "GET /stations" do
    it "rejects anonymous users" do
      get stations_path
      expect(response).to have_http_status(401)
    end
  end
end
