\timing on

DROP TABLE IF EXISTS DATA_IN_2010;

CREATE TABLE DATA_IN_2010 (
    vendor_id TEXT,
    pickup_datetime TEXT,
    dropoff_datetime TEXT,
    passenger_count TEXT,
    trip_distance TEXT,
    pickup_longitude TEXT,
    pickup_latitude TEXT,
    rate_code TEXT,
    store_and_fwd_flag TEXT,
    dropoff_longitude TEXT,
    dropoff_latitude TEXT,
    payment_type TEXT,
    fare_amount TEXT,
    surcharge TEXT,
    mta_tax TEXT,
    tip_amount TEXT,
    tolls_amount TEXT,
    total_amount TEXT
);

\copy data_in_2010 ( vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-01.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2010 (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount) from '/home/piotr/nytc/yt_2010-12.csv' DELIMITER ',' CSV HEADER

INSERT INTO DATA_IN_ALL SELECT
	CASE WHEN PICKUP_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(PICKUP_DATETIME,	'yyyy-mm-dd HH24:MI:SS') ELSE NULL END AS PICKUP_DATETIME,
	CASE WHEN DROPOFF_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(DROPOFF_DATETIME, 'yyyy-mm-dd HH24:MI:SS')  ELSE NULL END AS DROPOFF_DATETIME,
	CASE WHEN PICKUP_LONGITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LONGITUDE::FLOAT ELSE 0 END AS PICKUP_LONGITUDE,
	CASE WHEN PICKUP_LATITUDE~E'^-?\\d*\\.\\d*' THEN PICKUP_LATITUDE::FLOAT ELSE 0 END AS PICKUP_LATITUDE,
	CASE WHEN DROPOFF_LONGITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LONGITUDE::FLOAT ELSE 0 END AS DROPOFF_LONGITUDE,
	CASE WHEN DROPOFF_LATITUDE~E'^-?\\d*\\.\\d*' THEN DROPOFF_LATITUDE::FLOAT ELSE 0 END AS DROPOFF_LATITUDE
FROM DATA_IN_2010;



