class AddTwoColumnsToWorks < ActiveRecord::Migration[5.1]
  def up
  	add_column :works, :stop_reason, :string
  	add_column :works, :comment, :text
  end

  def down
  	remove_column :works, :stop_reason
  	remove_column :works, :comment
  end
end
