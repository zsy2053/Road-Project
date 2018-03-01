class AddVersionColumnToRoadOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :road_orders, :version, :string
  end
end
