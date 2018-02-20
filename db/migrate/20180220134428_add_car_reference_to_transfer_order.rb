class AddCarReferenceToTransferOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :transfer_orders, :assembly, references: :users, index: true
    add_foreign_key :transfer_orders, :cars, column: :assembly_id
  end
end
