class ChangeBackOrderFocusedPartFlagToBoolean < ActiveRecord::Migration[5.1]
  def up
    # add tmp column with new type
    add_column :back_orders, :focused_part_flag_tmp, :boolean, default: false
    
    # update tmp column with value
    BackOrder.where("focused_part_flag <> ''").update_all(:focused_part_flag_tmp => true)
    
    # remove old column since data moved over
    remove_column :back_orders, :focused_part_flag
    
    # rename column to original name
    rename_column :back_orders, :focused_part_flag_tmp, :focused_part_flag
  end
  
  def down
    # add tmp column with new type
    add_column :back_orders, :focused_part_flag_tmp, :string
    
    # update tmp column with value
    BackOrder.where(:focused_part_flag => true).update_all(:focused_part_flag_tmp => 'true')
    
    # remove old column since data moved over
    remove_column :back_orders, :focused_part_flag
    
    # rename column to original name
    rename_column :back_orders, :focused_part_flag_tmp, :focused_part_flag
  end
end
