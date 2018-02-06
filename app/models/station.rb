class Station < ApplicationRecord
  belongs_to :contract
  
  validates_presence_of :name, :code
  
  validates :name, uniqueness: { scope: :contract }
  validates :code, uniqueness: { scope: :contract }
end
