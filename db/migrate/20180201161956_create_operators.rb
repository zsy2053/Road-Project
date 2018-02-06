class CreateOperators < ActiveRecord::Migration[5.1]
  def change
    create_table :operators do |t|
      t.string :first_name
      t.string :last_name
      t.string :employee_number
      t.string :badge
      t.boolean :suspended, default: false
      t.timestamps
    end
    add_index :operators, :badge, unique: true
    add_index :operators, :employee_number, unique: true
  end
end
