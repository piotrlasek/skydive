\timing on

DROP TABLE IF EXISTS DATA_IN_2014;

CREATE TABLE DATA_IN_2014 (
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
    --
    );

\copy data_in_2014 from '/home/piotr/nytc/yt_2014-01.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-02.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-03.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-04.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-05.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-06.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-07.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-08.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-09.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-10.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-11.csv' DELIMITER ',' CSV HEADER
\copy data_in_2014 from '/home/piotr/nytc/yt_2014-12.csv' DELIMITER ',' CSV HEADER

INSERT INTO DATA_IN_ALL SELECT
	case when pickup_datetime~e'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' then to_timestamp(pickup_datetime,	'yyyy-mm-dd hh24:mi:ss') else null end as pickup_datetime,
	case when dropoff_datetime~e'^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$' then to_timestamp(dropoff_datetime, 'yyyy-mm-dd hh24:mi:ss')  else null end as dropoff_datetime,
	case when pickup_longitude~e'^-?\\d*\\.\\d*' then pickup_longitude::float else 0 end as pickup_longitude,
	case when pickup_latitude~e'^-?\\d*\\.\\d*' then pickup_latitude::float else 0 end as pickup_latitude,
	case when dropoff_longitude~e'^-?\\d*\\.\\d*' then dropoff_longitude::float else 0 end as dropoff_longitude,
	case when dropoff_latitude~e'^-?\\d*\\.\\d*' then dropoff_latitude::float else 0 end as dropoff_latitude
FROM DATA_IN_2014;
