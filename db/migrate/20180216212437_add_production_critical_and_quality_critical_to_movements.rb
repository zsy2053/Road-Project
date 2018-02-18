class AddProductionCriticalAndQualityCriticalToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :production_critical, :boolean
    add_column :movements, :quality_critical, :boolean
  end
end
