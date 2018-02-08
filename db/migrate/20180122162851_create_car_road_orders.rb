class CreateCarRoadOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :car_road_orders do |t|
      t.references :car, foreign_key: true
      t.references :road_order, foreign_key: true

      t.timestamps
    end
  end
end
