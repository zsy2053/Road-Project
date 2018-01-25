class CreateBackOrder < ActiveRecord::Migration[5.1]
  def change
    create_table :back_orders do |t|
      
      t.string :bom_exp_no
      t.references :station, foreign_key: true
      t.references :contract, foreign_key: true
      t.string :mrp_cont
      t.string :cri
      t.string :component
      t.string :material_description
      t.string :sort_string
      t.string :assembly
      t.string :order
      t.string :item_text_line_1
      t.integer :qty
      t.string :vendor_name
      t.string :material
      t.timestamps

    end
  end
end
