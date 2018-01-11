class CreateDefinitions < ActiveRecord::Migration[5.1]
  def change
    create_table :definitions do |t|
      t.references :road_order, foreign_key: true, index: true
      t.string :work_location
      t.string :day
      t.string :shift
      t.string :sequence_number
      t.string :name
      t.text :description
      t.integer :expected_duration
      t.integer :breaks
      t.time :expected_start
      t.time :expected_end
      t.boolean :serialized

      t.timestamps
    end
  end
end
