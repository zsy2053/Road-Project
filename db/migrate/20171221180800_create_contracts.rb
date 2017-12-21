class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.references :site, foreign_key: true
      t.string :status, :null => false, default: "draft"
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
