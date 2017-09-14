-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Loads data and transforms data into an appropriate
--                  format.
-- ------------------------------------------------------------------
-- HISTORY
-- 4.05.2017  Columns names have to be fixed in all years from 2009
--            until 2015 and data has to be imported again!!!
-- 08.05.2017 New file craeted, based on 1-data-preprocessing.sql
-- 11.05.2017 Cleaning section added

-- ==================================================================

\timing on

DROP TABLE IF EXISTS DATA_IN_ALL;

CREATE TABLE DATA_IN_ALL (
  PICKUP_DATETIME TIMESTAMP,
  DROPOFF_DATETIME TIMESTAMP,
  PICKUP_LONGITUDE FLOAT,
  PICKUP_LATITUDE FLOAT,
  DROPOFF_LONGITUDE FLOAT,
  DROPOFF_LATITUDE FLOAT
);

\i insert-2009.sql
\i insert-2010.sql
\i insert-2011.sql
\i insert-2012.sql
\i insert-2013.sql
\i insert-2014.sql
\i insert-2015.sql
\i insert-2016.sql

ALTER TABLE DATA ADD COLUMN TRIP_TIME INTEGER;

-- Computing trip time

UPDATE
    DATA
SET
    TRIP_TIME =
    CASE
        WHEN
            DROPOFF_DATETIME > PICKUP_DATETIME AND
            EXTRACT(EPOCH FROM DROPOFF_DATETIME - PICKUP_DATETIME) >=0
        THEN
            EXTRACT(EPOCH FROM DROPOFF_DATETIME - PICKUP_DATETIME) / 60 ELSE 0 END;

-- 87 minutes / 270 mln records

select now();
create index on data(pickup_longitude);
select now();
create index on data(pickup_latitude); -- 
select now();
create index on data(dropoff_longitude); -- 30  minutes
select now();
create index on data(dropoff_latitude); -- 30 minutes
select now();
create index on data(trip_time);
select now();
create index on data(pickup_datetime); -- 25 minutes
select now();
select initialize_pi_cube();
select now();

-- Cleaning

select
        min(pickup_longitude) as PICK_LON_MIN, max(pickup_longitude) as PICK_LON_MAX,
        min(pickup_latitude) as PICK_LAT_MIN, max(pickup_latitude) as PICK_LAT_MAX,
        min(dropoff_longitude) as DROP_LON_MIN, max(dropoff_longitude) as DROP_LON_MAX,
        min(dropoff_latitude) as DROP_LAT_MIN, max(dropoff_latitude) as DROP_LAT_MAX
from data;

-- time


delete from data where pickup_latitude < 38.7128;
delete from data where pickup_latitude > 42.7128;
delete from data where pickup_longitude < -76.0059;
delete from data where pickup_longitude > -72.0059;

delete from data where dropoff_latitude < 38.7128;
delete from data where dropoff_latitude > 42.7128;
delete from data where dropoff_longitude < -76.0059;
delete from data where dropoff_longitude > -72.0059;

-- ----------------------------------------------------

delete from data where pickup_latitude < .7128;
delete from data where pickup_latitude > 40.7011;
delete from data where pickup_longitude < -76.0059;
delete from data where pickup_longitude > -72.0059;

delete from data where dropoff_latitude < 38.7128;
delete from data where dropoff_latitude > 42.7128;
delete from data where dropoff_longitude < -76.0059;
delete from data where dropoff_longitude > -72.0059;


-- Number of records for the years 2015 - 2016: 


