class Position < ApplicationRecord
  after_initialize :init
  
  belongs_to :car_road_order
  
  validates_presence_of :name
  validates :name, uniqueness: { scope: :car_road_order_id }

  validates :allows_multiple, :inclusion => { :in => [true, false] }
  
  def init
    self.allows_multiple = false if self.allows_multiple.nil? 
  end
end
