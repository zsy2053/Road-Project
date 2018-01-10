class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :category
      t.string :filename
      t.string :content_type
      t.string :status

      t.timestamps
    end
  end
end
