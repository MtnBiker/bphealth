class AddLocalzonetoBloodpressure < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_pressures, :statzone, :integer
  end
end
