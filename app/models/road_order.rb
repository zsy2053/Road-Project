class RoadOrder < ApplicationRecord
  before_save :set_contract
  
  belongs_to :station
  belongs_to :contract
  belongs_to :author, class_name: 'User'
  
  validates_presence_of :car_type, :start_car
  
  has_many :definitions
  
  # distinct list of the positions available for this road order
  serialize :positions, Array
  
  # hash describing the days and respective shifts spanned by this road order
  serialize :day_shifts, Hash
  
  # helper function to get the days spanned by this road order irrespective of shifts
  def days
    return self.day_shifts.keys
  end
  
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
