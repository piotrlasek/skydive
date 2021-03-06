\timing on

drop table if exists data_in_2009;

create table data_in_2009 (
    vendor_name text,
    trip_pickup_datetime text,
    trip_dropoff_datetime text,
    passenger_count text,
    trip_distance text,
    start_lon text,
    start_lat text,
    rate_code text,
    store_and_forward text,
    end_lon text,
    end_lat text,
    payment_type text,
    fare_amt text,
    surcharge text,
    mta_tax text,
    tip_amt text,
    tolls_amt text,
    total_amt text
);

\copy data_in_2009 from '/home/piotr/nytc/yt_2009-01.csv' delimiter ',' csv header
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2009 from '/home/piotr/nytc/yt_2009-12.csv' DELIMITER ',' CSV HEADER

INSERT INTO DATA_IN_ALL SELECT
	CASE WHEN TRIP_PICKUP_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(TRIP_PICKUP_DATETIME,	'yyyy-mm-dd HH24:MI:SS') ELSE NULL END AS PICKUP_DATETIME,
	CASE WHEN TRIP_DROPOFF_DATETIME~E'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' THEN TO_TIMESTAMP(TRIP_DROPOFF_DATETIME, 'yyyy-mm-dd HH24:MI:SS')  ELSE NULL END AS DROPOFF_DATETIME,
	CASE WHEN START_LON~E'^-?\\d*\\.\\d*' THEN START_LON::FLOAT ELSE 0 END AS PICKUP_LONGITUDE,
	CASE WHEN START_LAT~E'^-?\\d*\\.\\d*' THEN START_LAT::FLOAT ELSE 0 END AS PICKUP_LATITUDE,
	CASE WHEN END_LON~E'^-?\\d*\\.\\d*' THEN END_LON::FLOAT ELSE 0 END AS DROPOFF_LONGITUDE,
	CASE WHEN END_LAT~E'^-?\\d*\\.\\d*' THEN END_LAT::FLOAT ELSE 0 END AS DROPOFF_LATITUDE
FROM DATA_IN_2009;
