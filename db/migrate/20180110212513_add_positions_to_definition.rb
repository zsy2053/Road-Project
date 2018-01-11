class AddPositionsToDefinition < ActiveRecord::Migration[5.1]
  def change
    add_column :definitions, :positions, :string
  end
end
