\timing on

DROP TABLE IF EXISTS DATA_IN_2016;

CREATE TABLE DATA_IN_2016 (
    vendorid text, 
    tpep_pickup_datetime text, 
    tpep_dropoff_datetime text, 
    passenger_count text, 
    trip_distance text, 
    pickup_longitude text, 
    pickup_latitude text, 
    ratecodeid text, 
    store_and_fwd_flag text, 
    dropoff_longitude text, 
    dropoff_latitude text, 
    payment_type text, 
    fare_amount text, 
    extra text, 
    mta_tax text, 
    tip_amount text, 
    tolls_amount text, 
    improvement_surcharge text, 
    total_amount text             
    );

\copy data_in_2016 from '/home/piotr/nytc/yt_2016-01.csv' DELIMITER ',' CSV HEADER
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
	case when tpep_pickup_datetime~e'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' then to_timestamp(tpep_pickup_datetime,	'yyyy-mm-dd hh24:mi:ss') else null end as pickup_datetime,
	case when tpep_dropoff_datetime~e'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' then to_timestamp(tpep_dropoff_datetime, 'yyyy-mm-dd hh24:mi:ss')  else null end as dropoff_datetime,
	case when pickup_longitude~e'^-?\\d*\\.\\d*' then pickup_longitude::float else 0 end as pickup_longitude,
	case when pickup_latitude~e'^-?\\d*\\.\\d*' then pickup_latitude::float else 0 end as pickup_latitude,
	case when dropoff_longitude~e'^-?\\d*\\.\\d*' then dropoff_longitude::float else 0 end as dropoff_longitude,
	case when dropoff_latitude~e'^-?\\d*\\.\\d*' then dropoff_latitude::float else 0 end as dropoff_latitude
FROM DATA_IN_2016;

