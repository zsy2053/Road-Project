require 'rails_helper'

RSpec.describe Upload, type: :model do
  
  it "has a valid factory" do
    expect(FactoryBot.build(:upload)).to be_valid
  end
  
  it { should belong_to(:user) }
  
  it { is_expected.to validate_presence_of(:filename) }
  
  it { is_expected.to validate_presence_of(:content_type) }
  
  it { is_expected.to validate_presence_of(:category) }
  
  describe "status attribute" do
    it "should default to 'draft'" do
      item = Upload.new
      expect(item).to be_draft
    end
    
    it "should not get overwritten" do
      item = Upload.new(filename: 'text.txt', user: FactoryBot.build_stubbed(:user), status: 'uploading')
      expect(item).to be_uploading
    end
  end
  
  describe "path method" do
    context "when not persisted" do
      it "returns nothing" do
        item = FactoryBot.build(:upload)
        expect(item).to_not be_persisted
        expect(item.path).to be_blank
      end
    end
    
    context "when persisted" do
      it "returns the expected path for large IDs" do
        item = FactoryBot.build_stubbed(:upload, id: 123456789, category: 'folder', filename: 'filename.ext')
        expect(item).to be_persisted
        expect(item.path).to eq('uploads/folder/123/456/789/filename.ext')
      end
      
      it "returns the expected path for small IDs" do
        item = FactoryBot.build_stubbed(:upload, id: 11, category: 'folder', filename: 'filename.ext')
        expect(item).to be_persisted
        expect(item.path).to eq('uploads/folder/000/000/011/filename.ext')
      end
    end
  end
  
  describe "signed_url non-persistent attribute" do
    let(:upload) { FactoryBot.build_stubbed(:upload) }
    
    it "responds to the getter" do
      expect(upload).to respond_to(:signed_url)
    end
    
    it "responds to the setter" do
      expect(upload).to respond_to("#{:signed_url}=")
    end
  end
  
end
