class StopReason < ApplicationRecord
  validates :label, presence: true, uniqueness: true
  validates :should_alert, :inclusion => { :in => [true, false] }
end
