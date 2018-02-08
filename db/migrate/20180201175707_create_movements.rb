class CreateMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :movements do |t|
      t.references :definition, foreign_key: true
      t.integer :actual_duration
      t.integer :percent_complete
      t.references :car_road_order, foreign_key: true
      t.text :comments

      t.timestamps
    end
  end
end
