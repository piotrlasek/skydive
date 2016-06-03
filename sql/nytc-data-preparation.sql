CREATE TABLE data (
  medallion text,
  hack_license text,
  vendor_id text,
  rate_code text,
  store_and_fwd_flag text,
  pickup_datetime text,
  dropoff_datetime text,
  passenger_count text,
  trip_time_in_secs text,
  trip_distance text,
  pickup_longitude text,
  pickup_latitude text,
  dropoff_longitude text,
  dropoff_latitude text
);

\copy data from '/home/piotr/trip_data_1.csv' with delimiter ',';

DROP TABLE data2;
CREATE TABLE
  data2
AS SELECT
  store_and_fwd_flag,
  vendor_id,
  rate_code::integer,
  to_timestamp(pickup_datetime, 'yyyy-mm-dd HH24:MI:SS') as pickup_datetime,
  to_timestamp(dropoff_datetime, 'yyyy-mm-dd HH24:MI:SS') as dropoff_datetime,
  CASE WHEN passenger_count != '' THEN passenger_count::integer ELSE 0 END as passenger_count,
  CASE WHEN trip_time_in_secs != '' THEN trip_time_in_secs::integer ELSE 0 END as trip_time_in_secs,
  CASE WHEN trip_distance != '' THEN trip_distance::float ELSE 0 END as trip_distance,
  CASE WHEN pickup_longitude != '' THEN pickup_longitude::float ELSE 0 END as pickup_longitude,
  CASE WHEN pickup_latitude != '' THEN pickup_latitude::float ELSE 0 END as pickup_latitude,
  CASE WHEN dropoff_longitude != '' THEN dropoff_longitude::float ELSE 0 END as dropoff_longitude,
  CASE WHEN dropoff_latitude != '' THEN dropoff_latitude::float ELSE 0 END as dropoff_latitude
FROM
  data
limit 50000;
