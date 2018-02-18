class AddPositionToOperator < ActiveRecord::Migration[5.1]
  def change
    add_reference :operators, :position, foreign_key: true
  end
end
