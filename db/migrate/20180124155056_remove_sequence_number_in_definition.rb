class RemoveSequenceNumberInDefinition < ActiveRecord::Migration[5.1]
  def up
    remove_column :definitions, :sequence_number, :string
  end

  def down
    add_column :definitions, :sequence_number, :string, :null => false
  end
end
