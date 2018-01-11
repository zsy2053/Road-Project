class AddCompletionToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :progress, :integer
    add_column :uploads, :total, :integer
  end
end
