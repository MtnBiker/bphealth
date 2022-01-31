class AddZonenameToBloodPressure < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_pressures, :zonename, :string
  end
end
