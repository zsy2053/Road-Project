class AddNewRoadOrderAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :road_orders, :work_centre, :string
    add_column :road_orders, :module, :string
  end
end
