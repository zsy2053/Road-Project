class RoadOrderDetailsSerializer < ActiveModel::Serializer
  attributes :id, :car_type, :start_car, :work_centre, :module, :day_shifts, :positions, :import_url, :version
  
  has_many :definitions
  belongs_to :station
  belongs_to :contract
  belongs_to :author
  
  def import_url
    if object.import && object.import.file
      object.import.file.authenticated_url
    end
  end
end
