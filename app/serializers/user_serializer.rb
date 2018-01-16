class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role, :site_id, :site_name, :contracts
  
  def site_name
    object.site.name
  end
  
  def contracts
    object.contracts
  end
end
