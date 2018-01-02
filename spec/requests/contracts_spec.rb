require 'rails_helper'

RSpec.describe "Contracts", type: :request do
  describe "GET /contracts" do
    it "rejects anonymous users" do
      get contracts_path
      expect(response).to have_http_status(401)
    end
  end
end
