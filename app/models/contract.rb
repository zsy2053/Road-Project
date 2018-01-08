class Contract < ApplicationRecord
  belongs_to :site
  has_many :stations
  enum status: { open: "open", closed: "closed", draft: "draft" }
end
