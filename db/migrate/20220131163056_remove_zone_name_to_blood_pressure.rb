class RemoveZoneNameToBloodPressure < ActiveRecord::Migration[7.0]
  def change
    remove_column :blood_pressures, :zone_name, :string
  end
end
