class ChangeDefinitionAttributesToNotBlank < ActiveRecord::Migration[5.1]
  def up
  	change_column :definitions, :work_location, :string, :null => false
  	change_column :definitions, :day, :string, :null => false
  	change_column :definitions, :shift, :string, :null => false
  	change_column :definitions, :sequence_number, :string, :null => false
  	change_column :definitions, :name, :string, :null => false
  	change_column :definitions, :description, :text, :null => false
  	change_column :definitions, :expected_duration, :integer, :null => false
  	change_column :definitions, :breaks, :integer, :null => false
  	change_column :definitions, :expected_start, :time, :null => false
  	change_column :definitions, :expected_end, :time, :null => false
  	change_column :definitions, :serialized, :boolean, :null => false
  	change_column :definitions, :positions, :string, :null => false
  end

  def down
  	change_column :definitions, :work_location, :string
  	change_column :definitions, :day, :string
  	change_column :definitions, :shift, :string
  	change_column :definitions, :sequence_number, :string
  	change_column :definitions, :name, :string
  	change_column :definitions, :description, :text
  	change_column :definitions, :expected_duration, :integer
  	change_column :definitions, :breaks, :integer
  	change_column :definitions, :expected_start, :time
  	change_column :definitions, :expected_end, :time
  	change_column :definitions, :serialized, :boolean
  	change_column :definitions, :positions, :string
  end
end
