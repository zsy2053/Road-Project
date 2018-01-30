class AddFocusedPartColumnToBackOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :back_orders, :focused_part_flag, :string
    remove_column :back_orders, :material, :string
  end
end
