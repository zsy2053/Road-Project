class RoadOrderSerializer < ActiveModel::Serializer
  attributes :id, :station, :station_name, :contract, :contract_name, :car_type, :start_car, :work_centre, :module, :day_shifts, :max_car, :version

  def station_name
    if object.station
      object.station.name
    end
  end

  def contract_name
    if object.contract
      object.contract.name
    end
  end
  
  def max_car
    if object.cars.length > 0
      object.cars.maximum(:number)
    else
      0
    end
  end
end
