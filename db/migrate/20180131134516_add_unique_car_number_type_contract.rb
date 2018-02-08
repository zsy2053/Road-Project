class AddUniqueCarNumberTypeContract < ActiveRecord::Migration[5.1]
  def change
    add_index :cars, [:number, :car_type, :contract_id], unique: true
  end
end
