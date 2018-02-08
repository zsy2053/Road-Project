class AddUniqueCarRoadOrderIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :car_road_orders, [:car_id, :road_order_id], unique: true
  end
end
