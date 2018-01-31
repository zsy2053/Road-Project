class Station < ApplicationRecord
  belongs_to :contract
  
  validates :name, uniqueness: { scope: :contract }
  validates :code, uniqueness: { scope: :contract }
end
