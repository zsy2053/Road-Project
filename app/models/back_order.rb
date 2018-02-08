class BackOrder < ApplicationRecord
  before_save :set_contract
  
  belongs_to :station
  belongs_to :contract
  
  validates :cri, :focused_part_flag, :inclusion => {:in => [true, false]}
  
  def set_contract
      self.contract = self.station.contract unless self.contract == self.station.contract
  end
end
