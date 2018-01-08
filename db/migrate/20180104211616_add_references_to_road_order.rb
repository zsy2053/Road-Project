class AddReferencesToRoadOrder < ActiveRecord::Migration[5.1]
  def change
  	add_reference :road_orders, :station, foreign_key: true
  	add_reference :road_orders, :author, references: :users, foreign_key: true
  end
end
