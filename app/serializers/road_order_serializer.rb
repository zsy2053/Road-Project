class RoadOrderSerializer < ActiveModel::Serializer
  attributes :id, :station, :contract, :car_type, :start_car, :work_centre, :module

  def station
    if object.station
      object.station.name
    end
  end

  def contract
    if object.contract
      object.contract.name
    end
  end
end
