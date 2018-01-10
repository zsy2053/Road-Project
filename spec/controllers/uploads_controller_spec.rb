require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  
  let(:user) { FactoryBot.create(:user) }
  
  let(:valid_attributes) {
    { category: 'category', filename: 'text.txt', content_type: 'text/plain', user_id: user.id }
  }

  let(:invalid_attributes) {
    { filename: '' }
  }
  
  before(:each) do
    add_jwt_header(request, user)
  end
  
=begin
  # this route is not available yet, but might be in the future
  # TODO: update spec to ensure a user only sees their own uploads
  describe "GET #index" do
    subject { get :index, {} }
    
    it "returns a success response" do
      upload = Upload.create! valid_attributes
      subject
      expect(response).to be_success
    end
    
    it "returns a collection without the signed_url attribute" do
      upload = Upload.create! valid_attributes
      subject
      
      result = JSON.parse(response.body)
      expect(result.size).to eq(1)
      expect(result[0].keys).not_to include('signed_url')
    end
  end
=end
  
  describe "GET #show" do
    let(:upload) { Upload.create! valid_attributes }
    subject { get :show, params: {id: upload.to_param} }
    it "returns a success response" do
      subject
      expect(response).to be_success
    end
    
    it "returns a response without the signed_url attribute" do
      subject
      result = JSON.parse(response.body)
      expect(result.keys).not_to include('signed_url')
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Upload" do
        expect {
          post :create, params: {upload: valid_attributes}
        }.to change(Upload, :count).by(1)
      end

      it "renders a JSON response with the new upload and signed_url attribute" do
        post :create, params: {upload: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(upload_url(Upload.last))
        
        result = JSON.parse(response.body)
        expect(result.keys).to include('signed_url')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new upload" do

        post :create, params: {upload: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
  
=begin
  # this route is not available yet, but might be in the future
  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { filename: 'file2.txt' }
      }

      it "updates the requested upload" do
        upload = Upload.create! valid_attributes
        put :update, params: {id: upload.to_param, upload: new_attributes}
        upload.reload
        expect(upload.filename).to eq('file2.txt')
      end

      it "renders a JSON response with the upload without signed_url attribute" do
        upload = Upload.create! valid_attributes

        put :update, params: {id: upload.to_param, upload: valid_attributes}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        
        result = JSON.parse(response.body)
        expect(result.keys).not_to include('signed_url')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the upload" do
        upload = Upload.create! valid_attributes

        put :update, params: {id: upload.to_param, upload: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
=end

=begin
  # this route is not available yet, but might be in the future
  describe "DELETE #destroy" do
    it "destroys the requested upload" do
      upload = Upload.create! valid_attributes
      expect {
        delete :destroy, params: {id: upload.to_param}
      }.to change(Upload, :count).by(-1)
    end
  end
=end
end
