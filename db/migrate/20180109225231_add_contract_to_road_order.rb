class AddContractToRoadOrder < ActiveRecord::Migration[5.1]
  def up
    add_reference :road_orders, :contract, foreign_key: true
    
    execute "update road_orders left join stations on road_orders.station_id = stations.id set road_orders.contract_id = stations.contract_id where road_orders.contract_id is null;"
  end

  def down
    remove_reference :road_orders, :contract, index: true, foreign_key: true
  end
end
