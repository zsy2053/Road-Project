class AddReferencesToRoadOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :road_orders, :station, foreign_key: true
    add_reference :road_orders, :author, references: :users, index: true
    add_foreign_key :road_orders, :users, column: :author_id
  end
end
