class CreateStopReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :stop_reasons do |t|
      t.string :label
      t.boolean :should_alert
    end
  end
end
