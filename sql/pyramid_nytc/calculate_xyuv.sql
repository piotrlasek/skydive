-- Piotr Lasek
-- created on 9/8/2018 
-- normalizing longitutes and latitudes and calculating zoo values 

-- iunput: data_1bln
-- output: data_xyuvz

-- requriements: interlacebitstrings function

drop function tozoo2(bigint, bigint);

-- returns an array of bit varyings of size two
create function tozoo2(x bigint, y bigint) returns bit(64) as $$
    select cast(interlacebitstrings(array[cast(y as bit(32)),
        cast(x as bit(32))]) as bit(64))
$$ language sql immutable;

drop function calculate_xyuv2() cascade;

create function calculate_xyuv2() returns int as $$
declare                                                                 
	picklatwidth double precision;
    picklonwidth double precision;
    droplatwidth double precision;
    droplonwidth double precision;
    width double precision;
    minpiclon double precision;
    minpiclat double precision;
    mindrolon double precision;
    mindrolat double precision;
	x int;
    y int;
    u int;
    v int;
    maxint bigint; -- 2^32 - 1, using bigint because int would not be able to handle this
    result int;
begin                                                                   
    maxint := 4294967295;

	picklatwidth := (select max(pickup_latitude) - min(pickup_latitude)   from data_1bln);
	picklonwidth := (select max(pickup_longitude) - min(pickup_longitude) from data_1bln);
	droplatwidth := (select max(dropoff_latitude) - min(dropoff_latitude) from data_1bln);
	droplonwidth := (select max(dropoff_longitude) - min(dropoff_longitude) from data_1bln);

    width := (select max(widths) from unnest(array[picklatwidth, picklonwidth,
        droplatwidth, droplonwidth]) widths);

	RAISE NOTICE 'width: %', width;            

    minpiclat := (select min(pickup_latitude) from data_1bln);
    minpiclon := (select min(pickup_longitude) from data_1bln);
    mindrolat := (select min(dropoff_latitude) from data_1bln);
    mindrolon := (select min(dropoff_longitude) from data_1bln);

	drop table if exists data_xyuv_22;

	create unlogged table data_xyuv_22 as                                    
	select
        cast(maxint * (pickup_longitude - minpiclon) / width as bigint) as x,
        cast(maxint * (pickup_latitude - minpiclat) / width as bigint) as y,
        cast(maxint * (dropoff_longitude - mindrolon) / width as bigint) as u,
        cast(maxint * (dropoff_latitude - mindrolat) / width as bigint) as v

        -- tozoo(cast(maxint * (pickup_longitude - minpiclon) / width as bigint),
        --    cast(maxint * (pickup_latitude - minpiclat) / width as bigint)) as zooa,
        --tozoo(cast(maxint * (dropoff_longitude - mindrolon) / width as bigint),
        --    cast(maxint * (dropoff_latitude - mindrolat) / width as bigint)) as zoob
	from data_1bln limit 100000; 

	return result;                                                               
end;
$$ language plpgsql;

 -- calculating zoo values for xy, uv

 --                     immut.
 -- 10^2        61          -
 -- 10^3       201        168
 -- 10^4      1637       1596
 -- 10^5     15700      15420
 -- 10^6    159172          -
 -- 10^7         -    1583681 (26 min.)
 -- 10^8         -          -
 -- 10^9         -  154943000 (43 h. - est)
