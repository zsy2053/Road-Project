class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :employee_id, :phone, :email, :username, :role, :site_id, :site_name, :contracts
  
  def site_name
    object.site.name
  end
  
  def contracts
    object.contracts
  end
end
