class BpWithTimeZones < ActiveRecord::Migration[7.0]
  def up
     execute <<-SQL
     CREATE VIEW public.bp_time_with_zones AS
      SELECT blood_pressures.id,
         blood_pressures.statdate,
         blood_pressures.statdate::time with time zone AS stattime,
         blood_pressures.systolic,
         blood_pressures.diastolic,
         blood_pressures.heartrate
        FROM public.blood_pressures
       ORDER BY blood_pressures.statdate;
     SQL
   end

   def down
     execute "DROP VIEW view_bp_time_with_zones"
   end
end
