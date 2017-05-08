\timing on

DROP TABLE IF EXISTS DATA_IN_2011;

CREATE TABLE DATA_IN_2011 (
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

\copy data_in_2011 from '/home/piotr/nytc/yt_2011-01.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2011 from '/home/piotr/nytc/yt_2011-12.csv' DELIMITER ',' CSV HEADER

INSERT INTO DATA_IN_ALL SELECT
	VENDOR_ID,
	CASE WHEN PICKUP_LONGITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LONGITUDE::FLOAT ELSE 0 END AS PICKUP_LONGITUDE,
	CASE WHEN PICKUP_LATITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LATITUDE::FLOAT ELSE 0 END AS PICKUP_LATITUDE,
	CASE WHEN DROPOFF_LONGITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LONGITUDE::FLOAT ELSE 0 END AS DROPOFF_LONGITUDE,
	CASE WHEN DROPOFF_LATITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LATITUDE::FLOAT ELSE 0 END AS DROPOFF_LATITUDE,
	CASE WHEN PICKUP_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(PICKUP_DATETIME,	'yyyy-mm-dd HH24:MI:SS') ELSE NULL END AS PICKUP_DATETIME,
	CASE WHEN DROPOFF_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(DROPOFF_DATETIME, 'yyyy-mm-dd HH24:MI:SS')  ELSE NULL END AS DROPOFF_DATETIME,
	CASE WHEN TRIP_DISTANCE~E'^\\d*\\.\\d*' THEN TRIP_DISTANCE::FLOAT ELSE 0 END AS TRIP_DISTANCE,
	CASE WHEN FARE_AMOUNT~E'^\\d*\\.\\d*' THEN FARE_AMOUNT::FLOAT ELSE 0 END AS FARE_AMOUNT,
	CASE WHEN SURCHARGE~E'^\\d*\\.\\d*' THEN SURCHARGE::FLOAT ELSE 0 END AS SURCHARGE,
	CASE WHEN MTA_TAX~E'^\\d*\\.\\d*' THEN MTA_TAX::FLOAT ELSE 0 END AS MTA_TAX,
	CASE WHEN TOLLS_AMOUNT~E'^\\d*\\.\\d*' THEN TOLLS_AMOUNT::FLOAT ELSE 0 END AS TOLLS_AMOUNT,
	CASE WHEN TOTAL_AMOUNT~E'^\\d*\\.\\d*' THEN TOTAL_AMOUNT::FLOAT ELSE 0 END AS TOTAL_AMOUNT,
	CASE WHEN PASSENGER_COUNT~E'^\\d+$'  THEN PASSENGER_COUNT::INTEGER ELSE 0 END AS PASSENGER_COUNT,
	CASE WHEN RATE_CODE~E'^\\d+$' THEN RATE_CODE::INTEGER ELSE  -1 END AS RATE_CODE,
	STORE_AND_FWD_FLAG
FROM DATA_IN_2011;
