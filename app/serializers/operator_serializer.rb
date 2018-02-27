class OperatorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :employee_number, :suspended, :position_id
end
