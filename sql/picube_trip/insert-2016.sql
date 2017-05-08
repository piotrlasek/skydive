\timing on

DROP TABLE IF EXISTS DATA_IN_2016;

CREATE TABLE DATA_IN_2016 (
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

\copy data_in_2016 from '/home/piotr/nytc/yt_2016-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2016 from '/home/piotr/nytc/yt_2016-12.csv' DELIMITER ',' CSV HEADER

INSERT INTO DATA_IN_ALL SELECT
	VENDOR_ID,
FROM DATA_IN_2015;