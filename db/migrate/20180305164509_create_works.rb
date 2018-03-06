class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.integer :parent_id
      t.integer :completion, :default => 0
      t.datetime :actual_time
      t.datetime :override_time
      t.string :action
      t.string :position
      t.string :parent_type

      t.timestamps
    end
    add_reference :works, :contract, foreign_key: true
    add_reference :works, :operator, foreign_key: true
    add_index :works, [:parent_type, :parent_id]
  end
end
