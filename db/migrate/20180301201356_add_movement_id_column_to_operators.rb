class AddMovementIdColumnToOperators < ActiveRecord::Migration[5.1]
  def up
  	add_column :operators, :movement_id, :integer
  end

  def down
  	remove_column :operators, :movement_id
  end
end
