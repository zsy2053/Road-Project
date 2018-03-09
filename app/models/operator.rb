class Operator < ApplicationRecord
  belongs_to :site
  belongs_to :position, optional: true
  belongs_to :movement, optional: true
  validates_uniqueness_of :employee_number, :badge
  validates_presence_of :employee_number, :badge, :last_name, :first_name
  validates_length_of :last_name, :minimum => 2
  validates_length_of :first_name, :minimum => 2
end
