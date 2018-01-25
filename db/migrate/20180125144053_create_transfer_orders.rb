class CreateTransferOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :transfer_orders do |t|
      t.integer :order, :null => false
      t.string :delivery_device
      t.string :priority, :null => false
      t.string :reason_code, :null => false
      t.string :name
      t.string :code
      t.string :installation
      t.string :to_number, :null => false
      t.string :car, :null => false
      t.string :sort_string, :null => false
      t.datetime :date_entered
      t.datetime :date_received_3pl
      t.datetime :date_staging
      t.datetime :date_shipped_bt
      t.datetime :date_received_bt
      t.datetime :date_production
      t.timestamps
    end
  end
end
