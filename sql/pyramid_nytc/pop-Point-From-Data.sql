-- Piotr Lasek
-- created on 9/8/2018 
-- normalizing longitutes and latitudes and calculating zoo values 

-- iunput: data_1bln
-- output: data_xyuvz

-- requriements: interlacebitstrings function

--drop function tozoo(bigint, bigint);

-- returns an array of bit varyings of size two
--create function tozoo(x bigint, y bigint) returns bit(64) as $$
--    select cast(interlacebitstrings(array[cast(y as bit(32)),
--        cast(x as bit(32))]) as bit(64))
--$$ language sql immutable;

\timing on

drop function poppointfromdata() cascade;

create function poppointfromdata() returns int as $$
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

	drop table if exists point_xyuv;

	create unlogged table point_xyuv as                                    
	select
        cast(maxint * (pickup_longitude - minpiclon) / width as bigint) as x,
        cast(maxint * (pickup_latitude - minpiclat) / width as bigint) as y,
        cast(maxint * (dropoff_longitude - mindrolon) / width as bigint) as u,
        cast(maxint * (dropoff_latitude - mindrolat) / width as bigint) as v
        /*cast(interlacebitstrings(array[cast(y as bit(32)),
            cast(x as bit(32))]) as bit(64)) as zoo*/
        /*morton_enc(cast(maxint * (pickup_longitude - minpiclon) / width as bigint),
            cast(maxint * (pickup_latitude - minpiclat) / width as bigint))::bit(64) as zoo*/
        /*morton_enc(cast(maxint * (dropoff_longitude - mindrolon) / width as bigint),
            cast(maxint * (dropoff_latitude - mindrolat) / width as bigint))::bit(64) as zoob*/
	from data_1bln; 


	return result;                                                               
end;
$$ language plpgsql;

-- select 1 from data_xyuv where cast(interlacebitstrings(array[cast(y as bit(32)),cast(x as bit(32))]) as bit(64)) = zooa limit 10;

 -- calculating zoo values for xy, uv
 -- using the interlacebitstring function

 --         interl.   iter.immut.         morton_enc
 -- 10^2        61              -
 -- 10^3       201            168                 56
 -- 10^4      1637           1596                 71
 -- 10^5     15700          15420                137
 -- 10^6    159172              -               1153
 -- 10^7         -        1583681              13121  (13 sec.)
 -- 10^8         -              -
 -- 10^9         -      154943000 (est.)     1790250  (30 min.)
