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

