class AddColumnsToContract < ActiveRecord::Migration[5.1]
  def change
  	add_column :contracts, :description, :string
  	add_column :contracts, :minimum_offset, :integer
  	add_column :contracts, :planned_start, :datetime
  	add_column :contracts, :planned_end, :datetime
  	add_column :contracts, :actual_start, :datetime
  	add_column :contracts, :actual_end, :datetime
  end
end
