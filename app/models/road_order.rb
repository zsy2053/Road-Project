class RoadOrder < ApplicationRecord
  before_save :set_contract
  
  belongs_to :station
  belongs_to :contract
  belongs_to :author, class_name: 'User'
  
  validates_presence_of :car_type, :work_centre
  validates :start_car, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  has_many :car_road_orders, dependent: :destroy
  has_many :cars, through: :car_road_orders
  
  validates :version, presence: true

  validate :minimum_start_car
  def minimum_start_car
    # can only validate if a start_car, car_type, station, and contract are present
    if self.start_car.present? && self.car_type.present? && self.station.present?
      # determine contract
      tmpContract = self.contract
      if tmpContract.nil? && self.station.present?
        tmpContract = self.station.contract
      end
      
      if tmpContract.present?
        # must have a start_car greater than any other matching road order
        roMax = RoadOrder.where(:car_type => self.car_type, :station_id => self.station_id).maximum('start_car')
        if roMax.present?
          unless self.start_car > roMax
            errors.add(:start_car, ("must exceed, " + roMax.to_s + ", the car number from the most recent road order"))
          else
            # find largest car number of the car type that has been built for this station
            carMax = Car.includes(car_road_orders: [:road_order]).where(:car_type => self.car_type, car_road_orders: { road_orders: { station_id: self.station.id } }).maximum('number')
            if carMax.present?
              if self.start_car < (carMax + tmpContract.minimum_offset)
                errors.add(:start_car, ("must exceed current car number [" + carMax.to_s + "] by " + tmpContract.minimum_offset.to_s))
              end
            end
          end
        else
          # this is the first road order for this car type, start car must be 1
          unless self.start_car == 1
            errors.add(:start_car, 'must be 1 for the first road order for a new car type')
          end
        end
      end
    end
  end
  
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
