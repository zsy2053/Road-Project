class BackOrderSerializer < ActiveModel::Serializer
  attributes :id, :station, :station_name, :contract, :contract_name, :bom_exp_no,
             :mrp_cont, :cri, :component, :material_description, :sort_string,
             :assembly, :order, :item_text_line_1, :qty, :vendor_name, :focused_part_flag

  def station_name
    if object.station
      object.station.name
    end
  end

  def contract_name
    if object.contract
      object.contract.name
    end
  end
end
