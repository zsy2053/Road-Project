class Work < ApplicationRecord
  before_validation :set_contract
  
  belongs_to :parent, polymorphic: true
  belongs_to :contract
  belongs_to :operator
  belongs_to :stop_reason, optional: true
  validates :parent_type, presence: true, :inclusion => {:in => ["Snag", "Movement"]}
  validates :action, presence: true
  validates :position, presence: true
  validates :completion, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates_datetime :actual_time, { allow_blank: false }
  validates_datetime :override_time, { allow_blank: false }
  
  validate :override_time_for_same_operator
  def override_time_for_same_operator
    # can only validate if override time and operator are present
    if self.override_time.present? and self.operator_id.present?
      # get the largest time index for this operator
      last_time = Work.where(:operator_id => self.operator_id).maximum(:override_time)
      if last_time.present? && last_time > self.override_time
        # return error message with timestamp -- use floor to remove milliseconds since not useful
        errors.add(:override_time, 'cannot preceed last time entry of [' + last_time.to_f.floor.to_s + ']')
      end
    end
  end
  
  # automatically assign contract based on parent before validations run
  def set_contract
    if self.parent_id
      parent_contract = nil
      
      if self.parent_type == 'Movement'
        tmp = Movement.find_by_id(self.parent_id)
        parent_contract = tmp.definition.road_order.contract
      end
      
      if parent_contract.present?
        self.contract = parent_contract
      end
    end
  end
end
