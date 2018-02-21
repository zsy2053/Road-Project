class CarRoadOrderSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :car
  belongs_to :road_order

  has_one :station, through: :road_order
  has_one :contract, through: :road_order

  has_many :positions
  class PositionSerializer < ActiveModel::Serializer
    attributes :id, :name, :allows_multiple, :operators
  end

  has_many :movements
  class MovementSerializer < ActiveModel::Serializer
    attributes :id, :work_location, :actual_duration, :comments, :percent_complete,
      :day, :shift, :name, :description, :expected_duration, :breaks, :expected_start,
      :expected_end, :serialized, :positions, :production_critical, :quality_critical

    def work_location
      object.definition.work_location
    end

    def day
      object.definition.day
    end

    def shift
      object.definition.shift
    end

    def name
      object.definition.name
    end

    def description
      object.definition.description
    end

    def expected_duration
      object.definition.expected_duration
    end

    def breaks
      object.definition.breaks
    end

    def expected_start
      object.definition.expected_start
    end

    def expected_end
      object.definition.expected_end
    end

    def serialized
      object.definition.serialized
    end

    def positions
      object.definition.positions
    end
  end
end
