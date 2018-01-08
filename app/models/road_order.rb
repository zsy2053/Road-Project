class RoadOrder < ApplicationRecord
  belongs_to :station
  has_one :contract, :through => :station
  belongs_to :author, class_name: 'User'
  validates_presence_of :car_type, :start_car
  
# This method handles json render. Should be improved using jbuilder or serializers in future.
  def as_json(options={})
    super(:only => [:car_type, :start_car],
          :include => {
            :station => {:only => [:name]},
            :contract => {:only => [:name]}
          }
    )
  end
end
