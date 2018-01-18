class AddSuspendedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :suspended, :boolean, null: false, default: false
  end
end
