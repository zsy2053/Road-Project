class RoadOrderSerializer < ActiveModel::Serializer
  attributes :id, :station, :station_name, :contract, :contract_name, :car_type, :start_car, :work_centre, :module

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
end
