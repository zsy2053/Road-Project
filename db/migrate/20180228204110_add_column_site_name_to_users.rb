class AddColumnSiteNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :site_name_text, :string
  end
end
