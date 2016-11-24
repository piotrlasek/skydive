-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     Novermber 1 , 2016
-- Description:     Data preparation.
-- ==================================================================

-- 2009                  2010               2011               2012               2013               2014               2015
-- VENDOR_NAME           VENDOR_ID          VENDOR_ID          VENDOR_ID          VENDOR_ID          VENDOR_ID          VENDORID 
-- TRIP_PICKUP_DATETIME  PICKUP_DATETIME    PICKUP_DATETIME    PICKUP_DATETIME    PICKUP_DATETIME    PICKUP_DATETIME    TPEP_PICKUP_DATETIME 
-- TRIP_DROPOFF_DATETIME DROPOFF_DATETIME   DROPOFF_DATETIME   DROPOFF_DATETIME   DROPOFF_DATETIME   DROPOFF_DATETIME   TPEP_DROPOFF_DATETIME 
-- PASSENGER_COUNT       PASSENGER_COUNT    PASSENGER_COUNT    PASSENGER_COUNT    PASSENGER_COUNT    PASSENGER_COUNT    PASSENGER_COUNT 
-- TRIP_DISTANCE         TRIP_DISTANCE      TRIP_DISTANCE      TRIP_DISTANCE      TRIP_DISTANCE      TRIP_DISTANCE      TRIP_DISTANCE 
-- START_LON             PICKUP_LONGITUDE   PICKUP_LONGITUDE   PICKUP_LONGITUDE   PICKUP_LONGITUDE   PICKUP_LONGITUDE   PICKUP_LONGITUDE 
-- START_LAT             PICKUP_LATITUDE    PICKUP_LATITUDE    PICKUP_LATITUDE    PICKUP_LATITUDE    PICKUP_LATITUDE    PICKUP_LATITUDE 
-- RATE_CODE             RATE_CODE          RATE_CODE          RATE_CODE          RATE_CODE          RATE_CODE          RATECODEID 
-- STORE_AND_FORWARD     STORE_AND_FWD_FLAG STORE_AND_FWD_FLAG STORE_AND_FWD_FLAG STORE_AND_FWD_FLAG STORE_AND_FWD_FLAG STORE_AND_FWD_FLAG 
-- END_LON               DROPOFF_LONGITUDE  DROPOFF_LONGITUDE  DROPOFF_LONGITUDE  DROPOFF_LONGITUDE  DROPOFF_LONGITUDE  DROPOFF_LONGITUDE 
-- END_LAT               DROPOFF_LATITUDE   DROPOFF_LATITUDE   DROPOFF_LATITUDE   DROPOFF_LATITUDE   DROPOFF_LATITUDE   DROPOFF_LATITUDE 
-- PAYMENT_TYPE          PAYMENT_TYPE       PAYMENT_TYPE       PAYMENT_TYPE       PAYMENT_TYPE       PAYMENT_TYPE       PAYMENT_TYPE 
-- FARE_AMT              FARE_AMOUNT        FARE_AMOUNT        FARE_AMOUNT        FARE_AMOUNT        FARE_AMOUNT        FARE_AMOUNT 
-- SURCHARGE             SURCHARGE          SURCHARGE          SURCHARGE          SURCHARGE          SURCHARGE          EXTRA 
-- MTA_TAX               MTA_TAX            MTA_TAX            MTA_TAX            MTA_TAX            MTA_TAX            MTA_TAX 
-- TIP_AMT               TIP_AMOUNT         TIP_AMOUNT         TIP_AMOUNT         TIP_AMOUNT         TIP_AMOUNT         TIP_AMOUNT 
-- TOLLS_AMT             TOLLS_AMOUNT       TOLLS_AMOUNT       TOLLS_AMOUNT       TOLLS_AMOUNT       TOLLS_AMOUNT       TOLLS_AMOUNT 
-- TOTAL_AMT             TOTAL_AMOUNT       TOTAL_AMOUNT       TOTAL_AMOUNT       TOTAL_AMOUNT       TOTAL_AMOUNT       IMPROVEMENT_SURCHARGE 
--                                                                                                                      TOTAL_AMOUNT           
-- Numbers of records
-- 2009 170896055
-- 2010 144971391
-- 2011 176897199
-- 2012 46099576     -> corrected
-- 2013 44516019     -> corrected
-- 2014 165114361
-- 2015 51622901     -> corrected

-- DATA_IN_2009
ALTER TABLE DATA_IN_2009 RENAME STORE_AND_FORWARD TO STORE_AND_FWD_FLAG;
ALTER TABLE DATA_IN_2009 RENAME VENDOR_NAME TO VENDOR_ID;
ALTER TABLE DATA_IN_2009 RENAME TRIP_PICKUP_DATETIME TO PICKUP_DATETIME;
ALTER TABLE DATA_IN_2009 RENAME TRIP_DROPOFF_DATETIME TO DROPOFF_DATETIME;
ALTER TABLE DATA_IN_2009 RENAME START_LON TO PICKUP_LONGITUDE;
ALTER TABLE DATA_IN_2009 RENAME START_LAT TO PICKUP_LATITUDE;
ALTER TABLE DATA_IN_2009 RENAME END_LON TO DROPOFF_LONGITUDE;
ALTER TABLE DATA_IN_2009 RENAME END_LAT TO DROPOFF_LATITUDE;
ALTER TABLE DATA_IN_2009 RENAME TIP_AMT TO TIP_AMOUNT;
ALTER TABLE DATA_IN_2009 RENAME TOLLS_AMT TO TOLLS_AMOUNT;
ALTER TABLE DATA_IN_2009 RENAME TOTAL_AMT TO TOTAL_AMOUNT;
ALTER TABLE DATA_IN_2009 RENAME FARE_AMT TO FARE_AMOUNT;

-- DATA_IN_2015
ALTER TABLE DATA_IN_2015 RENAME VENDORID TO VENDOR_ID;
ALTER TABLE DATA_IN_2015 RENAME TPEP_PICKUP_DATETIME TO PICKUP_DATETIME;
ALTER TABLE DATA_IN_2015 RENAME TPEP_DROPOFF_DATETIME TO DROPOFF_DATETIME;
yALTER TABLE DATA_IN_2015 RENAME RATECODEID TO RATE_CODE;
ALTER TABLE DATA_IN_2015 RENAME EXTRA TO SURCHARGE;

DROP TABLE IF EXISTS DATA_IN_2009;

CREATE TABLE DATA_IN_2009 (
    VENDOR_NAME TEXT,             
    TRIP_PICKUP_DATETIME TEXT,
    TRIP_DROPOFF_DATETIME TEXT,
    PASSENGER_COUNT TEXT,
    TRIP_DISTANCE TEXT,
    START_LON TEXT,
    START_LAT TEXT,
    RATE_CODE TEXT,
    STORE_AND_FORWARD TEXT,
    END_LON TEXT,
    END_LAT TEXT,
    PAYMENT_TYPE TEXT,
    FARE_AMT TEXT,
    SURCHARGE TEXT,
    MTA_TAX TEXT,
    TIP_AMT TEXT,
    TOLLS_AMT TEXT,
    TOTAL_AMT TEXT             
);

\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0901.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0902.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0903.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0904.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0905.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0906.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0907.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0908.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0909.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0910.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0911.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt0912.csv' DELIMITER ',' CSV HEADER

-- -----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS DATA_IN_2010;

CREATE TABLE DATA_IN_2010 (
    VENDOR_ID TEXT,
    PICKUP_DATETIME TEXT,
    DROPOFF_DATETIME TEXT,
    PASSENGER_COUNT TEXT,
    TRIP_DISTANCE TEXT,
    PICKUP_LONGITUDE TEXT,
    PICKUP_LATITUDE TEXT,
    RATE_CODE TEXT,
    STORE_AND_FWD_FLAG TEXT,
    DROPOFF_LONGITUDE TEXT,
    DROPOFF_LATITUDE TEXT,
    PAYMENT_TYPE TEXT,
    FARE_AMOUNT TEXT,
    SURCHARGE TEXT,
    MTA_TAX TEXT,
    TIP_AMOUNT TEXT,
    TOLLS_AMOUNT TEXT,
    TOTAL_AMOUNT TEXT            
);

\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2010-12.csv' DELIMITER ',' CSV HEADER

-- -----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS DATA_IN_2011;

CREATE TABLE DATA_IN_2011 (
    VENDOR_ID TEXT, 
    PICKUP_DATETIME TEXT, 
    DROPOFF_DATETIME TEXT, 
    PASSENGER_COUNT TEXT, 
    TRIP_DISTANCE TEXT, 
    PICKUP_LONGITUDE TEXT, 
    PICKUP_LATITUDE TEXT, 
    RATE_CODE TEXT, 
    STORE_AND_FWD_FLAG TEXT, 
    DROPOFF_LONGITUDE TEXT, 
    DROPOFF_LATITUDE TEXT, 
    PAYMENT_TYPE TEXT, 
    FARE_AMOUNT TEXT, 
    SURCHARGE TEXT, 
    MTA_TAX TEXT, 
    TIP_AMOUNT TEXT, 
    TOLLS_AMOUNT TEXT, 
    TOTAL_AMOUNT TEXT        
);

\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2011-12.csv' DELIMITER ',' CSV HEADER

---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS DATA_IN_2012;

CREATE TABLE DATA_IN_2012 (
    VENDOR_ID TEXT, 
    PICKUP_DATETIME TEXT, 
    DROPOFF_DATETIME TEXT, 
    PASSENGER_COUNT TEXT, 
    TRIP_DISTANCE TEXT, 
    PICKUP_LONGITUDE TEXT, 
    PICKUP_LATITUDE TEXT, 
    RATE_CODE TEXT, 
    STORE_AND_FWD_FLAG TEXT, 
    DROPOFF_LONGITUDE TEXT, 
    DROPOFF_LATITUDE TEXT, 
    PAYMENT_TYPE TEXT, 
    FARE_AMOUNT TEXT, 
    SURCHARGE TEXT, 
    MTA_TAX TEXT, 
    TIP_AMOUNT TEXT, 
    TOLLS_AMOUNT TEXT, 
    TOTAL_AMOUNT TEXT            
    );

\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2012 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2012-12.csv' DELIMITER ',' CSV HEADER

---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS DATA_IN_2013;

CREATE TABLE DATA_IN_2013 (
    VENDOR_ID TEXT, 
    PICKUP_DATETIME TEXT, 
    DROPOFF_DATETIME TEXT, 
    PASSENGER_COUNT TEXT, 
    TRIP_DISTANCE TEXT, 
    PICKUP_LONGITUDE TEXT, 
    PICKUP_LATITUDE TEXT, 
    RATE_CODE TEXT, 
    STORE_AND_FWD_FLAG TEXT, 
    DROPOFF_LONGITUDE TEXT, 
    DROPOFF_LATITUDE TEXT, 
    PAYMENT_TYPE TEXT, 
    FARE_AMOUNT TEXT, 
    SURCHARGE TEXT, 
    MTA_TAX TEXT, 
    TIP_AMOUNT TEXT, 
    TOLLS_AMOUNT TEXT, 
    TOTAL_AMOUNT TEXT
    );

\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2013 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2013-12.csv' DELIMITER ',' CSV HEADER


---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS DATA_IN_2014;

CREATE TABLE DATA_IN_2014 (
    VENDOR_ID TEXT, 
    PICKUP_DATETIME TEXT, 
    DROPOFF_DATETIME TEXT, 
    PASSENGER_COUNT TEXT, 
    TRIP_DISTANCE TEXT, 
    PICKUP_LONGITUDE TEXT, 
    PICKUP_LATITUDE TEXT, 
    RATE_CODE TEXT, 
    STORE_AND_FWD_FLAG TEXT, 
    DROPOFF_LONGITUDE TEXT, 
    DROPOFF_LATITUDE TEXT, 
    PAYMENT_TYPE TEXT, 
    FARE_AMOUNT TEXT, 
    SURCHARGE TEXT, 
    MTA_TAX TEXT, 
    TIP_AMOUNT TEXT, 
    TOLLS_AMOUNT TEXT, 
    TOTAL_AMOUNT TEXT            
    );

\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2014-12.csv' DELIMITER ',' CSV HEADER


---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS DATA_IN_2015;

CREATE TABLE DATA_IN_2015 (
    VENDORID TEXT, 
    TPEP_PICKUP_DATETIME TEXT, 
    TPEP_DROPOFF_DATETIME TEXT, 
    PASSENGER_COUNT TEXT, 
    TRIP_DISTANCE TEXT, 
    PICKUP_LONGITUDE TEXT, 
    PICKUP_LATITUDE TEXT, 
    RATECODEID TEXT, 
    STORE_AND_FWD_FLAG TEXT, 
    DROPOFF_LONGITUDE TEXT, 
    DROPOFF_LATITUDE TEXT, 
    PAYMENT_TYPE TEXT, 
    FARE_AMOUNT TEXT, 
    EXTRA TEXT, 
    MTA_TAX TEXT, 
    TIP_AMOUNT TEXT, 
    TOLLS_AMOUNT TEXT, 
    IMPROVEMENT_SURCHARGE TEXT, 
    TOTAL_AMOUNT TEXT             
    );

\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-01.csv' DELIMITER ',' CSV HEADER  
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2015 from '/share/CACHEDEV1_DATA/.qpkg/PostgreSQL/bin/NYCTC/yt_2015-12.csv' DELIMITER ',' CSV HEADER
