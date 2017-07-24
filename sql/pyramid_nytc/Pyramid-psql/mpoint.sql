drop table if exists mpoint;
create table mpoint(raw integer, zoo int);
insert into mpoint (raw, zoo) values
	(1,1),
	(2,6),
	(3,20),
	(4,21),
	(5,86),
	(6,90),
	(7,36),
	(8,39),
	(9,103),
	(10,60),
	(11,120),
	(12,140),
	(19,141),
	(13,156),
	(20,152),
	(14,142),
	(15,158),
	(16,207),
	(17,243),
	(18,187);

drop table if exists mPyramid cascade;

create table mPyramid (
    lev    int, -- level / stratum that this cell / tile is at
    zoo    int,   -- zoo : Z-order ordinal
    base   int,          -- level at which the tile is created
    lft    int,          -- level at which the tile touches left neighbour
    rght   int,          -- level at which the tile touches right neighbour
    point int,                -- aggr of number of points within tile
    constraint mpyramidPK
        primary key (lev, zoo)
);

	
drop function if exists madjAtLevel(zooA int, zooB int) cascade;

create function madjAtLevel (
    zooA    int,
    zooB    int
) returns int as $$
begin
    if (zooB is null) then
        return 0;
    elseif (zooA = zooB) then
        return 31 + 1;
    else
        return 31
                - floor(ln(zooA # zooB) / (2 * ln(2)));
    end if;
end;
$$ language plpgsql;

select madjatlevel(1,6);

select zoo as zooA, max(zoo) over (rows between 1 following and 1 following) as zooB, madjatlevel(zoo, max(zoo) over (rows between 1 following and 1 following)) from mpoint;

-- ---------------------------

drop function if exists mzooAtLevel(dim int, deepest int, level int, zoo int) cascade;

create function mzooAtLevel(
    dim int,
    deepest int,
    level int,
    zoo int
    ) returns int as $$
begin
    return floor(zoo / power(power(CAST((2) as int), dim), abs(deepest - level)));
end;
$$ language plpgsql;


-- -------------------------------


drop function if exists mpopbase();

create function mpopbase() returns int as $$
    declare dim_      int default  2;
    declare maxDepth_ int default 31;

    begin
        insert into mPyramid (lev, zoo, base, lft, rght, point)
        with
            -- group the raw data (Point) for "base" of pyramid
            mBase (zoo, point) as (
                select zoo, count(*)
                from mPoint
                group by zoo
            ),
            -- left  : at which level does this tile and the one left of it touch?
            -- right : at which level does this tile and the one right of it touch?
            mNeighbour (zoo, lft, rght, point) as (
                select  zoo, madjAtLevel(zoo,
                            max(zoo) over (
                                order by zoo asc
                                rows between 1 preceding
                                        and 1 preceding)
                            ),
                        madjAtLevel(zoo,
                            max(zoo) over (
                                order by zoo asc
                                rows between 1 following
                                        and 1 following)
                            ),
                        point
                from mBase
            ),
            -- ceiling : the level at which this tile touches a neighbour
            mCeiling (zoo, ceiling, lft, rght, point) as (
                select zoo,
                    case
                        when lft > rght then lft
                        else                 rght
                    end as ceiling,
                    lft, rght, point
                from mNeighbour
            )
        select ceiling, zoo, maxDepth_, lft, rght, point
        from mCeiling;

        return 0;
    end;
$$ language plpgsql;

drop function if exists mpopbystratum() cascade;

create function mpopbystratum() returns int as $$
    declare dim_      int default  2;
    declare maxDepth_ int default 31;
    declare stratum_  int;

    begin
        stratum_ = (select max(lev) from mPyramid);
        while stratum_ > 0 loop
            insert into mPyramid(lev, zoo, base, lft, rght, point)
            with
                -- Select out all cells at level stratum_,
                -- add zoo ("up") for super-cell.
                mSuperCell (lev, zoo, up, lft, rght, point, base) as (
                    select  lev, zoo,
                            mzooAtLevel(dim_, maxDepth_, lev - 1, zoo), -- => up
                            lft, rght, point, base
                    from mPyramid
                    where lev = stratum_
                ),
                -- REMOVED "rectify order by max" step.  DB2 does not need it.
                --     But other engines like PostgreSQL might.
                -- Aggregate by 'up'.
                mAggrCell (lev, zoo, up, row, lft, rght, point, base) as (
                    select  lev, zoo, up,
                            row_number() over (
                                    partition by up
                                    order by zoo asc),
                            min(lft)   over (partition by up),
                            min(rght)  over (partition by up),
                            sum(point) over (partition by up),
							base
                    from mSuperCell
                )
            -- Pick first row from each partition group to represent the super-cell.
            -- Pour into the stratum reserve.
            select  case
                        when lft > rght then lft
                        else                   rght
                    end,     -- the level of this new tile
                    zoo,   -- its zoo
                    lev - 1, -- its base level, where this cell was created
                    lft,    -- touches lft neighbour tile at this level
                    rght,   -- touches rght neighbour tile at this level
                    point   -- aggregated number of points in new tile
            from mAggrCell
            where row = 1;

            stratum_ = stratum_ - 1;
        end loop;

        return 0;
    end;
$$ language plpgsql;



---------------

select pickup_longitude + a = (select min(pickup_longitude) from data)* 10000000000000 from data limit 5;


with 
  min_long as (select min(pickup_longitude) from data),
  min_lat as (select min(pickup_latitude) from data),
  res as (select * from data limit 5)
select pickup_longitude + abs(select max(pickup_longitude) from min_long) from res;


with
  super as
    (select *, mzooatlevel(2, 31, lev-1, zoo) as up from mpyramid where lev = 31),
  aggr(lev, zoo, up, row, lft, rght, point) as
    (select    lev, zoo, up, 
               row_number() over (partition by up order by zoo asc),
               min(lft)   over (partition by up),
               min(rght)  over (partition by up),
			   --lft, rght,
			   sum(point) over (partition by up)
    from super)
select * from aggr;

select *, max(zoo) over (order by zoo asc rows between current row and 1 following) from pyramid where zoo = 43611097923584;

select zooatlevel(cast((2) as smallint), cast((31) as smallint), cast((15) as smallint), cast((43611097923584) as bigint));

select zooAtLevel(cast((2) as smallint), cast((31) as smallint), cast((30) as smallint), cast((2) as bigint));



  lev |            zoo | base | lft | rght | point |  zoo@lev-1
  -------------------------------------------------------------
   13 | 41422812086272 |   31 |  13 |   12 |     1 |        150
   13 | 41613938130944 |   31 |  12 |   13 |     1 |        151
   13 | 41751377084416 |   31 |  13 |   11 |     1 |        151
   13 | 42902428319744 |   31 |  11 |   13 |     1 |        156
   13 | 43213813448704 |   31 |  13 |   11 |     1 |        157
   16 | 43611097923584 |   31 |  11 |   16 |     1 |      10154
   16 | 43615392890880 |   31 |  16 |   13 |     1 |      10155
   13 | 43701292236800 |   31 |  13 |   10 |     1 |        158
   12 | 44126493999104 |   31 |  10 |   12 |     1 |         40
   14 | 44667659878400 |   31 |  12 |   14 |     1 |        650


select adjatlevel(cast((2) as smallint), cast((31) as smallint), cast((43611097923584) as bigint), cast((43213813448704) as bigint));
select adjatlevel(cast((2) as smallint), cast((31) as smallint), cast((43615392890880) as bigint), cast((43611097923584) as bigint));