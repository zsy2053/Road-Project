class AddAttributesToRoadOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :road_orders, :file_path, :string
    add_column :road_orders, :positions, :string
    add_column :road_orders, :day_shifts, :string
  end
end
