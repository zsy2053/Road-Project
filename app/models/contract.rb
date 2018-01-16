class Contract < ApplicationRecord
  belongs_to :site
  has_many :stations
  
  validates :minimum_offset, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum status: { open: "open", closed: "closed", draft: "draft" }
end
