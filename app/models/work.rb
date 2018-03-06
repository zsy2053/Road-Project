class Work < ApplicationRecord
  belongs_to :parent, polymorphic: true
  belongs_to :contract
  belongs_to :operator
  validates :parent_type, presence: true, :inclusion => {:in => ["Snag", "Movement"]}
  validates_datetime :actual_time, { allow_blank: false }
  validates_datetime :override_time, { allow_blank: true }
  validates :action, presence: true
  validates :position, presence: true
  validates :completion, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
