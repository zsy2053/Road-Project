class Car < ApplicationRecord
  belongs_to :contract
  
  has_many :car_road_orders
  has_many :road_orders, through: :car_road_orders
  
  validates_presence_of :car_type
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  validates :number, uniqueness: { scope: [:contract_id, :car_type] }
end
