class AddUserToUploads < ActiveRecord::Migration[5.1]
  def change
    add_reference :uploads, :user, index: true, foreign_key: true
  end
end
