class Access < ApplicationRecord
  belongs_to :user
  belongs_to :contract
  validates :user, uniqueness: { scope: :contract }
end
