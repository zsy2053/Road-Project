class BackOrder < ApplicationRecord
  after_initialize :default_values
  before_save :set_contract

  belongs_to :station
  belongs_to :contract

  validates :cri, :focused_part_flag, :inclusion => {:in => [true, false]}

  def default_values
      self.cri = false if self.cri.nil?
      self.focused_part_flag = false if self.focused_part_flag.nil?
  end
  
  def set_contract
      self.contract = self.station.contract unless self.contract == self.station.contract
  end
end
