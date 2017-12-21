require 'rails_helper'

RSpec.describe StationsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Station. As you add validations to Station, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      station = Station.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      station = Station.create! valid_attributes
      get :show, params: {id: station.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Station" do
        expect {
          post :create, params: {station: valid_attributes}, session: valid_session
        }.to change(Station, :count).by(1)
      end

      it "renders a JSON response with the new station" do

        post :create, params: {station: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(station_url(Station.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new station" do

        post :create, params: {station: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested station" do
        station = Station.create! valid_attributes
        put :update, params: {id: station.to_param, station: new_attributes}, session: valid_session
        station.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the station" do
        station = Station.create! valid_attributes

        put :update, params: {id: station.to_param, station: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the station" do
        station = Station.create! valid_attributes

        put :update, params: {id: station.to_param, station: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested station" do
      station = Station.create! valid_attributes
      expect {
        delete :destroy, params: {id: station.to_param}, session: valid_session
      }.to change(Station, :count).by(-1)
    end
  end

end