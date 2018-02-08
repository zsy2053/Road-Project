class AddUniqueCarRoadOrderDefinitionIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :movements, [:definition_id, :car_road_order_id], unique: true
  end
end
