class DefinitionSerializer < ActiveModel::Serializer
  attributes :id, :road_order_id, :work_location, :day, :shift, :sequence_number, :name, :description, :expected_duration, :breaks, :expected_start, :expected_end, :serialized, :positions
  
  def expected_start
    if object.expected_start
      object.expected_start.to_s
    end
  end
  
  def expected_end
    if object.expected_end
      object.expected_end.to_s
    end
  end
end
