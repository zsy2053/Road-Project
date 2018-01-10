require 'rails_helper'

RSpec.describe UploadSerializer, type: :serializer do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:serializer) { described_class.new(upload) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }
  
  context "basic upload" do
    let(:upload) { FactoryBot.build_stubbed(:upload, id: 11, category: 'roadorders', filename: 'filename.ext', content_type: 'text/plain', status: 'uploading', user: user) }
    
    it 'only contains expected keys' do
      expect(subject.keys).to contain_exactly(
        'id',
        'status',
        'user_id',
        'content_type',
        'category',
        'path'
      )
    end
    
    it 'returns expected id' do
      expect(subject['id']).to eq(11)
    end
    
    it 'returns expected status' do
      expect(subject['status']).to eq('uploading')
    end
    
    it 'returns expected user id' do
      expect(subject['user_id']).to eq(user.id)
    end
    
    it 'returns expected path' do
      expect(subject['path']).to eq('uploads/roadorders/000/000/011/filename.ext')
    end
    
    it 'returns expected content type' do
      expect(subject['content_type']).to eq('text/plain')
    end
    
    it 'returns expected category' do
      expect(subject['category']).to eq('roadorders')
    end
  end
  
  context "upload with transient attributes" do
    let(:upload) { FactoryBot.build_stubbed(:upload, id: 11, category: 'roadorders', filename: 'filename.ext', status: 'uploading', user: user, signed_url: 'signed_url') }
    
    it 'only contains expected keys' do
      expect(subject.keys).to contain_exactly(
        'id',
        'status',
        'user_id',
        'path',
        'content_type',
        'category',
        'signed_url'
      )
    end
    
    it 'returns expected id' do
      expect(subject['id']).to eq(11)
    end
    
    it 'returns expected status' do
      expect(subject['status']).to eq('uploading')
    end
    
    it 'returns expected user id' do
      expect(subject['user_id']).to eq(user.id)
    end
    
    it 'returns expected path' do
      expect(subject['path']).to eq('uploads/roadorders/000/000/011/filename.ext')
    end
    
    it 'returns expected content type' do
      expect(subject['content_type']).to eq('text/plain')
    end
    
    it 'returns expected signed_url' do
      expect(subject['signed_url']).to eq('signed_url')
    end
    
    it 'returns expected category' do
      expect(subject['category']).to eq('roadorders')
    end
  end
end
