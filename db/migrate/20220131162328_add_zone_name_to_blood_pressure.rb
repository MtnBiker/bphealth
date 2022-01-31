class AddZoneNameToBloodPressure < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_pressures, :zone_name, :string
  end
end
