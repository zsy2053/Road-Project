class AddImportToRoadOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :road_orders, :import, :string
  end
end
