class Operator < ApplicationRecord
  validates_uniqueness_of :employee_number, :badge
  validates_presence_of :employee_number, :badge
end