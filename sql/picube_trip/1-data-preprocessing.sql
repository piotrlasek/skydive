-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Loads data and transforms data into an appropriate
--                  format.
-- ==================================================================

\timing on

\i 0-clear-db.sql

CREATE TABLE data_in (
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

-- Copying data

\copy data_in from '~/NYCTC/trip_data_1.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_2.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_3.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_4.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_5.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_6.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_7.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_8.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_9.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_10.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_11.csv' with delimiter ',';
\copy data_in from '~/NYCTC/trip_data_12.csv' with delimiter ',';

-- Casting types of attributes

CREATE TABLE
  data
AS SELECT
  store_and_fwd_flag,
  vendor_id,
  CASE WHEN rate_code~E'^\\d+$' THEN rate_code::integer ELSE  -1 END as rate_code,
  CASE WHEN pickup_datetime~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN to_timestamp(pickup_datetime, 'yyyy-mm-dd HH24:MI:SS') ELSE NULL END as pickup_datetime,
  CASE WHEN dropoff_datetime~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN to_timestamp(dropoff_datetime, 'yyyy-mm-dd HH24:MI:SS')  ELSE NULL END as dropoff_datetime,
  CASE WHEN passenger_count~E'^\\d+$'  THEN passenger_count::integer ELSE 0 END as passenger_count,
  CASE WHEN trip_time_in_secs~E'^\\d+$' THEN trip_time_in_secs::integer ELSE 0 END as trip_time_in_secs,
  CASE WHEN trip_distance~E'^\\d*\\.\\d*' THEN trip_distance::float ELSE 0 END as trip_distance,
  CASE WHEN pickup_longitude~E'^-?\\d*\\.\\d*' THEN pickup_longitude::float ELSE 0 END as pickup_longitude,
  CASE WHEN pickup_latitude~E'^-?\\d*\\.\\d*' THEN pickup_latitude::float ELSE 0 END as pickup_latitude,
  CASE WHEN dropoff_longitude~E'^-?\\d*\\.\\d*' THEN dropoff_longitude::float ELSE 0 END as dropoff_longitude,
  CASE WHEN dropoff_latitude~E'^-?\\d*\\.\\d*' THEN dropoff_latitude::float ELSE 0 END as dropoff_latitude
FROM
  data_in
 limit 10;

-- 858066.863 ms
-- Result: 173 179 771
