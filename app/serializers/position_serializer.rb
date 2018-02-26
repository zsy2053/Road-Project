class PositionSerializer < ActiveModel::Serializer
  attributes :id, :name, :allows_multiple, :operators
end
