class Definition < ApplicationRecord
  belongs_to :road_order, inverse_of: :definitions
  
  validates_presence_of :name, :sequence_number, :day, :shift
  validates :expected_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :breaks, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :serialized, :inclusion => { :in => [true, false] }
  
  # distinct list of the positions assigned to this step
  serialize :positions, Array
  
  # override expected_start getter to return a dateless time
  def expected_start
    DatelessTime.new super
  end
  
  # override expected_end getter to return a dateless time
  def expected_end
    DatelessTime.new super
  end
end