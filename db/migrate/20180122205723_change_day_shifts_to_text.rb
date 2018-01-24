class ChangeDayShiftsToText < ActiveRecord::Migration[5.1]
  def up
    change_column :road_orders, :day_shifts, :text
  end
  
  def down
    # will cause trouble if you have strings longer than 255 characters.
    change_column :road_orders, :day_shifts, :string
  end
end
