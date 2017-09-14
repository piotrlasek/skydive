-- ===========================================================================
-- pop-WithIslands: 
-- 
-- Author:      Piotr Lasek 
-- Create date: 2017-07-18
-- History:   
---------------------------------------------------------------------------

-- ===========================================================================

-- ===========================================================================

create table if not exists pyramidwi (
    lev smallint not null,
    zoo bigint not null,
    hlzoo bigint not null,
    point int,
    constraint pyramidPKNI
        primary key(lev, zoo)
);

-- pop base no islands
create or replace function popbasewi() returns int as $$
    declare dim_      smallint default 2;
    declare maxDepth_ smallint default 31;

    begin
        insert into pyramidwi (lev, zoo, hlzoo, point)
        with
            Base (lev, zoo, hlzoo, point) as (
               select
                    maxDepth_,
                    zoo,
                    zooAtLevel(
                        cast((dim_) as smallint), cast((maxDepth_) as smallint),
                        cast((maxDepth_- 1) as smallint), cast((zoo) as bigint)),
                   count(*)
               from Point
               group by zoo
            )
       select *
       from Base;

       return 0;
    end;
$$ language plpgsql;

create or replace function popbystratumwi() returns int as $$
    declare dim_      smallint default 2;
    declare maxDepth_ smallint default 31;
    declare stratum   smallint default 0;

    begin
        stratum = maxDepth_;
        while stratum > 1 loop
	    RAISE NOTICE 'Building stratum %.', stratum -1;
            insert into pyramidwi (lev, zoo, hlzoo, point)
            with SuperCell (stratum, zoo, hlzoo, point) as (
               select stratum-1,
                      min(zoo),
                      zooAtLevel(
                        cast((dim_) as smallint), cast((maxDepth_) as smallint),
                        cast((stratum - 2) as smallint), cast((min(zoo)) as bigint)),
                        sum(point)
               from pyramidwi
               where lev = stratum
               group by hlzoo 
           )
           select *
              from SuperCell; 
           stratum = stratum - 1;
       end loop;

       return 0;
    end;
$$ language plpgsql;







