class TransferOrderSerializerSerializer < ActiveModel::Serializer
  attributes :id, :to_number, :car, :order,
  :installation, :sort_string, :date_entered, :date_received_3pl, :date_staging,
  :date_shipped_bt, :date_received_bt, :date_production, :delivery_device,
  :priority, :reason_code, :station, :contract, :station_name
end
