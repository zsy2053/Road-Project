class Contract < ApplicationRecord
  belongs_to :site
  enum status: { open: "open", closed: "closed", draft: "draft" }
end
