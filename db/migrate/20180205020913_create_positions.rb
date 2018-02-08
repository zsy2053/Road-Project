class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.string :name
      t.references :car_road_order, foreign_key: true
      t.boolean :allows_multiple

      t.timestamps
    end
  end
end
