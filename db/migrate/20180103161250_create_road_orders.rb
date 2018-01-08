class CreateRoadOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :road_orders do |t|
      t.string :car_type
      t.integer :start_car
      t.timestamps
    end
  end
end
