class CreateStations < ActiveRecord::Migration[5.1]
  def change
    create_table :stations do |t|
      t.references :contract, foreign_key: true
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
