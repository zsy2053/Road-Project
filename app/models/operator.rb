class Operator < ApplicationRecord
  belongs_to :site
  belongs_to :position, optional: true
  validates_uniqueness_of :employee_number, :badge
  validates_presence_of :employee_number, :badge
end
