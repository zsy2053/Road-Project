class AddAttributesToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :number, :string
    add_column :sites, :address_line_1, :string
    add_column :sites, :address_line_2, :string
    add_column :sites, :address_line_3, :string
    add_column :sites, :city, :string
    add_column :sites, :province, :string
    add_column :sites, :post_code, :string
    add_column :sites, :country, :string
    add_column :sites, :time_zone, :string
  end
end
