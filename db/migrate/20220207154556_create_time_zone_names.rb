class CreateTimeZoneNames < ActiveRecord::Migration[7.0]
  def change
    create_table :time_zone_names do |t|
      t.text :name
      t.text :abbrev
      t.interval :utc_offset
      t.boolean :is_dst

      t.timestamps
    end
  end
end

 # rails generate scaffold TimeZoneNames name:text abbrev:text utc_offset:interval is_dst:boolean. Should have been singlular