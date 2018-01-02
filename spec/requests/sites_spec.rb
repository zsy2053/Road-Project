require 'rails_helper'

RSpec.describe "Sites", type: :request do
  describe "GET /sites" do
    it "rejects anonymous users" do
      get sites_path
      expect(response).to have_http_status(401)
    end
  end
end
