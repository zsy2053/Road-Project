class Position < ApplicationRecord
  after_initialize :init

  belongs_to :car_road_order

  validates_presence_of :name
  validates :name, uniqueness: { scope: :car_road_order_id }

  validates :allows_multiple, :inclusion => { :in => [true, false] }

  has_many :operators
  validates :operators, :length => { :maximum => 1, :message => "can only have one operator" }, if: :does_not_allow_multiple
  def does_not_allow_multiple
    # returns false if and only if allows_multiple is true, false and nil will return true
    if self.allows_multiple === true
      return false
    else
      return true
    end
  end

  def init
    self.allows_multiple = false if self.allows_multiple.nil?
  end
end
