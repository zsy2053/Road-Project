class Movement < ApplicationRecord
  after_initialize :init

  belongs_to :definition
  has_one :road_order, through: :definition
  has_many :operators
  belongs_to :car_road_order

  validates :actual_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :percent_complete, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :definition_id, uniqueness: { scope: :car_road_order_id }

  validates :production_critical, :quality_critical, :inclusion => {:in => [true, false]}

  def init
    self.actual_duration = 0 if self.actual_duration.nil?
    self.percent_complete = 0 if self.percent_complete.nil?
    self.quality_critical = false if self.quality_critical.nil?
    self.production_critical = false if self.production_critical.nil?
  end
end
