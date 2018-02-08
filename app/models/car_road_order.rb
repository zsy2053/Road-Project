class CarRoadOrder < ApplicationRecord
  belongs_to :car
  belongs_to :road_order
  
  has_one :station, through: :road_order
  has_one :contract, through: :road_order
  
  has_many :movements, dependent: :destroy
  has_many :positions, dependent: :destroy
  
  validates :road_order_id, uniqueness: { scope: :car_id }
end
