class UploadSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :status, :path, :content_type, :category
  
  # add signed url if object being serialized has the attribute
  attribute :signed_url, if: :signed_url?
  def signed_url?
    true if object.signed_url
  end
end
