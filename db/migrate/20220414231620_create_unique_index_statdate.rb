class CreateUniqueIndexStatdate < ActiveRecord::Migration[7.0]
  def change
    add_index :blood_pressures, [:statdate, :systolic, :diastolic], unique: true
  end
end
