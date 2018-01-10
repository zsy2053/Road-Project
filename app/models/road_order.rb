class RoadOrder < ApplicationRecord
  before_save :set_contract
  belongs_to :station
  belongs_to :contract
  belongs_to :author, class_name: 'User'
  validates_presence_of :car_type, :start_car
# This method handles json render. Should be improved using jbuilder or serializers in future.
  def as_json(options={})
    super(:only => [:id, :car_type, :start_car],
          :include => {
            :station => {:only => [:name]},
            :contract => {:only => [:name]}
          }
    )
  end

  def set_contract
      self.contract = self.station.contract unless self.contract == self.station.contract
  end
end
