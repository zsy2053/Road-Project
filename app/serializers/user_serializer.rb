class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :employee_id, :phone, :email, :username, :role, :site_id, :site_name, :contracts, :suspended
    
  def site_name
    object.site.name
  end
  
  def contracts
    object.accesses.includes(:contract).map do |access|
      access.contract.as_json.merge!(access_id: access.id)
    end    
  end
end
