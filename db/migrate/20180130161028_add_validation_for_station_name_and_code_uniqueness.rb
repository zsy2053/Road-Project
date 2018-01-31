class AddValidationForStationNameAndCodeUniqueness < ActiveRecord::Migration[5.1]
  def change
    add_index :stations, [:name, :contract_id], unique: true
    add_index :stations, [:code, :contract_id], unique: true
  end
end
