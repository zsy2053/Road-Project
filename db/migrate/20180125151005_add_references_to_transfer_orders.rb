class AddReferencesToTransferOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :transfer_orders, :station, foreign_key: true
    add_reference :transfer_orders, :contract, foreign_key: true
  end
end
