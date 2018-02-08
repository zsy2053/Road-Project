class Movement < ApplicationRecord
  after_initialize :init
  
  belongs_to :definition
  belongs_to :car_road_order
  
  validates :actual_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  validates :percent_complete, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  validates :definition_id, uniqueness: { scope: :car_road_order_id }

  def init
    self.actual_duration = 0 if self.actual_duration.nil?
    self.percent_complete = 0 if self.percent_complete.nil?
  end
end
