class ChangeBackOrderCriToBoolean < ActiveRecord::Migration[5.1]
  def up
    # add tmp column with new type
    add_column :back_orders, :cri_tmp, :boolean, default: false
    
    # update tmp column with value
    BackOrder.where("cri <> ''").update_all(:cri_tmp => true)
    
    # remove old column since data moved over
    remove_column :back_orders, :cri
    
    # rename column to original name
    rename_column :back_orders, :cri_tmp, :cri
  end
  
  def down
    # add tmp column with new type
    add_column :back_orders, :cri_tmp, :string
    
    # update tmp column with value
    BackOrder.where(:cri => true).update_all(:cri_tmp => 'true')
    
    # remove old column since data moved over
    remove_column :back_orders, :cri
    
    # rename column to original name
    rename_column :back_orders, :cri_tmp, :cri
  end
end
