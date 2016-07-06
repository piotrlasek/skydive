-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Loads data and transforms data into an appropriate
--                  format.
-- ==================================================================

\timing on

\i 0-clear-db.sql

CREATE TABLE DATA_IN (
  MEDALLION TEXT,
  HACK_LICENSE TEXT,
  VENDOR_ID TEXT,
  RATE_CODE TEXT,
  STORE_AND_FWD_FLAG TEXT,
  PICKUP_DATETIME TEXT,
  DROPOFF_DATETIME TEXT,
  PASSENGER_COUNT TEXT,
  TRIP_TIME_IN_SECS TEXT,
  TRIP_DISTANCE TEXT,
  PICKUP_LONGITUDE TEXT,
  PICKUP_LATITUDE TEXT,
  DROPOFF_LONGITUDE TEXT,
  DROPOFF_LATITUDE TEXT
);

-- Copying data
-- ------------------------------------------------------------------

\copy DATA_IN FROM '~/NYCTC/trip_data_1.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_2.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_3.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_4.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_5.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_6.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_7.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_8.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_9.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_10.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_11.csv' WITH DELIMITER ',';
\copy DATA_IN FROM '~/NYCTC/trip_data_12.csv' WITH DELIMITER ',';

-- takes about *40 minutes*

-- Casting types of attributes
-- ------------------------------------------------------------------

CREATE TABLE
  DATA
AS SELECT
  STORE_AND_FWD_FLAG,
  VENDOR_ID,
  CASE WHEN RATE_CODE~E'^\\d+$' THEN RATE_CODE::INTEGER ELSE  -1 END AS RATE_CODE,
  CASE WHEN PICKUP_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(PICKUP_DATETIME, 'yyyy-mm-dd HH24:MI:SS') ELSE NULL END AS PICKUP_DATETIME,
  CASE WHEN DROPOFF_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(DROPOFF_DATETIME, 'yyyy-mm-dd HH24:MI:SS')  ELSE NULL END AS DROPOFF_DATETIME,
  CASE WHEN PASSENGER_COUNT~E'^\\d+$'  THEN PASSENGER_COUNT::INTEGER ELSE 0 END AS PASSENGER_COUNT,
  CASE WHEN TRIP_TIME_IN_SECS~E'^\\d+$' THEN TRIP_TIME_IN_SECS::INTEGER ELSE 0 END AS TRIP_TIME_IN_SECS,
  CASE WHEN TRIP_DISTANCE~E'^\\d*\\.\\d*' THEN TRIP_DISTANCE::FLOAT ELSE 0 END AS TRIP_DISTANCE,
  CASE WHEN PICKUP_LONGITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LONGITUDE::FLOAT ELSE 0 END AS PICKUP_LONGITUDE,
  CASE WHEN PICKUP_LATITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LATITUDE::FLOAT ELSE 0 END AS PICKUP_LATITUDE,
  CASE WHEN DROPOFF_LONGITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LONGITUDE::FLOAT ELSE 0 END AS DROPOFF_LONGITUDE,
  CASE WHEN DROPOFF_LATITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LATITUDE::FLOAT ELSE 0 END AS DROPOFF_LATITUDE
FROM
  DATA_IN;

-- 858066.863 ms
-- about *14 minutes*
-- Result: 173 179 771

-- Creating indexes
-- ------------------------------------------------------------------

CREATE INDEX ON DATA(PICKUP_LONGITUDE);
CREATE INDEX ON DATA(PICKUP_LATITUDE);
CREATE INDEX ON DATA(DROPOFF_LONGITUDE);
CREATE INDEX ON DATA(DROPOFF_LATITUDE);
CREATE INDEX ON DATA(TRIP_TIME_IN_SECS);
CREATE INDEX ON DATA(PICKUP_DATETIME);

-- TIME: 13 minutes each

CREATE INDEX ON DATA (
    PICKUP_LONGITUDE,
    PICKUP_LATITUDE,
    DROPOFF_LONGITUDE,
    DROPOFF_LATITUDE,
    PICKUP_DATETIME
);

-- TIME: 32 minutes
