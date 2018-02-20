class TransferOrder < ApplicationRecord
  before_validation :set_contract

  belongs_to :contract
  belongs_to :station
  belongs_to :assembly, class_name: 'Car', optional: true

  validates_presence_of :car, :order, :to_number, :installation, :sort_string, :priority, :reason_code

  def set_contract
    if self.station.present?
      self.contract = self.station.contract unless self.contract == self.station.contract
    end
  end
end
