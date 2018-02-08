class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :car_type
      t.integer :number
      t.references :contract, foreign_key: true

      t.timestamps
    end
  end
end
