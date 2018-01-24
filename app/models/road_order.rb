class RoadOrder < ApplicationRecord
  before_save :set_contract
  
  belongs_to :station
  belongs_to :contract
  belongs_to :author, class_name: 'User'
  
  validates_presence_of :car_type, :work_centre, :module, :start_car
  
  has_many :definitions, inverse_of: :road_order, :dependent => :destroy
  accepts_nested_attributes_for :definitions
  
  # distinct list of the positions available for this road order
  serialize :positions, Array
  
  # hash describing the days and respective shifts spanned by this road order
  serialize :day_shifts, Hash
  
  # stores the file used to generate this road order
  mount_uploader :import, RoadOrderImportUploader
  
  # helper function to get the days spanned by this road order irrespective of shifts
  def days
    return self.day_shifts.keys
  end
  
  def set_contract
      self.contract = self.station.contract unless self.contract == self.station.contract
  end
end
