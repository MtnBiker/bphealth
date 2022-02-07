json.extract! time_zone_name, :id, :name, :abbrev, :utc_offset, :is_dst, :created_at, :updated_at
json.url time_zone_name_url(time_zone_name, format: :json)
