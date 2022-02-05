class JanJul < ActiveRecord::Migration[7.0]
  def change
    <<-SQL
    /*
    Create the "tz_database_time_zones_extended" table.
    This is joined with "pg_timezone_names" to define the "extended_timezone_names" view.
    The facts change periodically. You must therefore re-run the "extended-timezone-names" kit
    on this directory and the companion "set-timezone-and-at-timezone-encapsulations" kit
    periodically (at atleast whenever the YB version is upgraded.

    It uses "jan_and_jul_tz_abbrevs_and_offsets()" to add
    "dst_abbrev" and "std_offset" to the downloaded "tz database" data.

    Fix up the few cases where "std_offset" and "dst_offset" are
    back-to-front in the "tz database" data.

    Eliminate any rows where the "tz database" STD and DST offsets
    disagree with the "Jan" and "Jul" offsets computed from "pg_timezone"names".
    */;

    drop view if exists tz_database_time_zones_extended_raw cascade;
    create view tz_database_time_zones_extended_raw as
    select
      p.name,
      f.jan_abbrev,
      f.jul_abbrev,
      f.jan_offset,
      f.jul_offset,
      t.std_offset,
      t.dst_offset,
      t.country_code,
      t.lat_long,
      t.region_coverage,
      t.status
    from
      pg_timezone_names as p
      inner join
      jan_and_jul_tz_abbrevs_and_offsets() as f using (name)
      inner join
      tz_database_time_zones_view as t using (name)
    -- Eliminates dirty data in YB 2.4.
    where p.utc_offset in (t.std_offset, t.dst_offset);

    drop table if exists bad_names cascade;
    create table bad_names(name text primary key);

    drop function if exists tz_database_time_zones_extended_good() cascade;
    create function tz_database_time_zones_extended_good()
      returns table (
        name             text,
        std_abbrev       text,
        dst_abbrev       text,
        std_offset       interval,
        dst_offset       interval,
        country_code     text,
        lat_long         text,
        region_coverage  text,
        status           text)
      language plpgsql
    as $body$
    declare
      jan_offset interval not null := make_interval();
      jul_offset interval not null := make_interval();
    begin
      delete from bad_names;
      for
        name,
        std_abbrev,
        dst_abbrev,
        jan_offset,
        jul_offset,
        std_offset,
        dst_offset,
        country_code,
        lat_long,
        region_coverage,
        status
      in
        (
          select
            e.name,
            e.jan_abbrev,
            e.jul_abbrev,
            e.jan_offset,
            e.jul_offset,
            e.std_offset,
            e.dst_offset,
            e.country_code,
            e.lat_long,
            e.region_coverage,
            e.status
          from tz_database_time_zones_extended_raw as e
        )
      loop
        -- Fix the bug from the "List of tz database time zones" page.
        if std_offset > dst_offset then
          declare
            temp constant interval not null := std_offset;
          begin
            std_offset := dst_offset;
            dst_offset := temp;
          end;
        end if;

        if
          (least   (std_offset, dst_offset) = least   (jan_offset, jul_offset))
          and
          (greatest(std_offset, dst_offset) = greatest(jan_offset, jul_offset))
        then
          case
            -- Northern hemisphere. No action needed.
            -- Explicit test as self-doc. The "case_not_found" error is unexpected.
            when (jan_offset = std_offset) and (jul_offset = dst_offset) then
              null;

            -- Southern hemisphere
            -- Twizzle std_abbrev (from jan_abbrev) and dst_abbrev (from jul_abbrev).
            when (jan_offset = dst_offset) and (jul_offset = std_offset) then
              declare
                temp constant text not null := std_abbrev;
              begin
                std_abbrev := dst_abbrev;
                dst_abbrev := temp;
              end;
            end case;

          return next;
        else
          insert into bad_names(name) values(name);
        end if;
      end loop;
    end;
    $body$;

    drop table if exists tz_database_time_zones_extended cascade;
    create table tz_database_time_zones_extended(
      name             text primary key,
      std_abbrev       text,
      dst_abbrev       text,
      std_offset       interval,
      dst_offset       interval,
      country_code     text,
      lat_long         text,
      region_coverage  text,
      status           text not null
      );

    insert into tz_database_time_zones_extended(
      name,
      std_abbrev,
      dst_abbrev,
      std_offset,
      dst_offset,
      country_code,
      lat_long,
      region_coverage,
      status)
    select
      name,
      std_abbrev,
      dst_abbrev,
      std_offset,
      dst_offset,
      country_code,
      lat_long,
      region_coverage,
      status
    from tz_database_time_zones_extended_good()
    -- Queries will be typically ordered by name.
    order by name;
    SQL
  end
end
