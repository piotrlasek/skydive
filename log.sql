nytcfull=# create index on data(pickup_longitude);
select now();
create index on data(dropoff_longitude); -- 30  minutes
select now();
create index on data(dropoff_latitude); -- 30 minutes
select now();
\






CREATE INDEX
nytcfull=# select now();
              now
-------------------------------
 2017-07-25 05:04:10.373675-05
(1 row)

nytcfull=# create index on data(pickup_latitude); --



CREATE INDEX
nytcfull=# select now();
              now
-------------------------------
 2017-07-25 06:25:09.047132-05
(1 row)

nytcfull=# create index on data(dropoff_longitude); -- 30  minutes
CREATE INDEX
nytcfull=# select now();
              now
-------------------------------
 2017-07-25 07:47:15.648118-05
(1 row)

nytcfull=# create index on data(dropoff_latitude); -- 30 minutes
CREATE INDEX
nytcfull=# select now();
              now
-------------------------------
 2017-07-25 09:07:55.926099-05
(1 row)



nytcfull=# select
nytcfull-#         min(pickup_longitude) as PICK_LON_MIN, max(pickup_longitude) as PICK_LON_MAX,
nytcfull-#         min(pickup_latitude) as PICK_LAT_MIN, max(pickup_latitude) as PICK_LAT_MAX,
nytcfull-#         min(dropoff_longitude) as DROP_LON_MIN, max(dropoff_longitude) as DROP_LON_MAX,
nytcfull-#         min(dropoff_latitude) as DROP_LAT_MIN, max(dropoff_latitude) as DROP_LAT_MAX
nytcfull-# from data;

 pick_lon_min | pick_lon_max | pick_lat_min | pick_lat_max | drop_lon_min | drop_lon_max | drop_lat_min | drop_lat_max
--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------
 -3509.015037 |  3570.224107 | -3579.139413 |   3577.13555 | -3579.139413 |  3460.426853 | -3579.139413 |    647561.71
 
 
    count
------------
 1310910867
(1 row)

Time: 393090.013 ms


delete from data where pickup_latitude < 38.7128;
delete from data where pickup_latitude > 42.7128;
delete from data where pickup_longitude < -76.0059;
delete from data where pickup_longitude > -72.0059;

delete from data where dropoff_latitude < 38.7128;
delete from data where dropoff_latitude > 42.7128;
delete from data where dropoff_longitude < -76.0059;
delete from data where dropoff_longitude > -72.0059;

delete from data where pickup_time > dropoff_time;




nytcfull=# select count(*) from data;




select count(*) from data where pickup_latitude < 38.7128;






   count
------------
 1310910867
(1 row)

Time: 1933392.988 ms
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=# select count(*) from data where pickup_latitude < 38.7128;
  count
----------
 85483632
(1 row)

Time: 1761945.479 ms
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=#
nytcfull=# create table data_raw as select * from data;
SELECT 1310910867
Time: 1284578.599 ms



DELETE 85483632
Time: 2943264.550 ms
nytcfull=# delete from data where pickup_latitude > 42.7128;
DELETE 35035
Time: 164537.900 ms
nytcfull=# delete from data where pickup_longitude < -76.0059;
DELETE 23518
Time: 197857.041 ms
nytcfull=# delete from data where pickup_longitude > -72.0059;
DELETE 224658
Time: 2888949.862 ms
nytcfull=#
nytcfull=# delete from data where dropoff_latitude < 38.7128;
DELETE 1156872
Time: 2116139.349 ms
nytcfull=# delete from data where dropoff_latitude > 42.7128;
DELETE 17864
Time: 144183.312 ms
nytcfull=# delete from data where dropoff_longitude < -76.0059;
DELETE 13475
Time: 135736.495 ms
nytcfull=# delete from data where dropoff_longitude > -72.0059;
DELETE 163348
Time: 2150371.687 ms
nytcfull=#
nytcfull=# delete from data where pickup_time > dropoff_time;
ERROR:  column "pickup_time" does not exist
LINE 1: delete from data where pickup_time > dropoff_time;
                               ^
Time: 82.016 ms



nytcfull=# \d data
                     Table "public.data"
      Column       |            Type             | Modifiers
-------------------+-----------------------------+-----------
 pickup_datetime   | timestamp without time zone |
 dropoff_datetime  | timestamp without time zone |
 pickup_longitude  | double precision            |
 pickup_latitude   | double precision            |
 dropoff_longitude | double precision            |
 dropoff_latitude  | double precision            |
 trip_time         | integer                     |
Indexes:
    "data_dropoff_latitude_idx" btree (dropoff_latitude)
    "data_dropoff_longitude_idx" btree (dropoff_longitude)
    "data_pickup_latitude_idx" btree (pickup_latitude)
    "data_pickup_longitude_idx" btree (pickup_longitude)

nytcfull=# delete from data where pickup_datetime > dropoff_datetime;
DELETE 249287
Time: 679536.254 ms




