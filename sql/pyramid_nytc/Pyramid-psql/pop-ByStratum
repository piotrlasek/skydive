-- ===========================================================================
-- pop-byStratum : after "pop-Base", finish populating table "Pyramid"
--     level by level (stratum by stratum) with aggreagted "boxes" (cells).
-- 
-- Author:      parke godfrey
-- Create date: 2017-04-04 
-- History:
--    2017-05-19 (Piotr Lasek) Porting to Postgresql
-- ---------------------------------------------------------------------------
-- To run this from the command line for DB2:
-- % db2 -td! -f pop-Base
-- To run this from the command line for Postgresql:
-- % psql -U piotr -d islands -a -f pop-ByStratum
-- ===========================================================================

drop function if exists popbystratum() cascade;

drop function if exists pbs() cascade;

create or replace function pbs() returns table
    (lev_ smallint, zoo_ bigint, base_ integer,
    lft_ smallint, rght_ smallint, point_ bigint, row_ bigint,
    up_ bigint) as $$
    declare dim_      smallint default  2;
    declare maxDepth_ smallint default 31;
    declare stratum_  smallint;

    begin
        stratum_ = 19; --(select max(lev) from Pyramid);
	    RAISE NOTICE 'Level %.', stratum_;

        return query
            with 
                SuperCell(lev, zoo, up, lft, rght, point) as (
                select
                   lev, zoo,
                   zooAtLevel(
                       cast((dim_) as smallint), cast((maxDepth_) as
                       smallint), cast((lev - 1) as smallint), cast((zoo)
                       as bigint)),
                   lft, rght, point
                from Pyramid
                where lev = stratum_ 
                -- 1072178917556894766
                ),
                AggrCell (lev, zoo, up, row, lft, rght, point) as (
                    select  lev, 
                            --min(zoo) over (partition by up), up,
                            zoo,
                            up,
                            row_number() over (
                                    partition by up
                                    order by zoo asc),
                            min(lft)   over (partition by up),
                            min(rght)  over (partition by up),
                            sum(point) over (partition by up)
                    from SuperCell[[
                )
            select  case
                        when lft > rght then lft-1
                        else                 rght-1
                    end,   -- the level of this new tile
                    zoo,   -- its zoo
                    lev,   -- its base level, where this cell was created
                    lft,   -- touches lft neighbour tile at this level
                    rght,  -- touches rght neighbour tile at this level
                    point, -- aggregated number of points in new tile
                    row,
                    up
            from AggrCell
             where row = 1;
    end;
$$ language plpgsql;

-- select popbystratum();

create function popbystratum() returns int as $$
    declare dim_      smallint default  2;
    declare maxDepth_ smallint default 31;
    declare stratum_  smallint;

    begin
        stratum_ = (select max(lev) from Pyramid);
	    RAISE NOTICE 'Level %.', stratum_;

        while stratum_ > 0 loop
            insert into Pyramid(lev, zoo, base, lft, rght, point)
            with
                -- Select out all cells at level stratum_,
                -- add zoo ("up") for super-cell.
                SuperCell (lev, zoo, up, lft, rght, point) as (
                    select
                       lev, zoo,
                       zooAtLevel(
                       cast((dim_) as smallint), cast((maxDepth_) as smallint),
                       cast((lev - 1) as smallint), cast((zoo) as bigint)),
                       lft, rght, point
                    from Pyramid
                    where lev = stratum_
                ),
                -- REMOVED "rectify order by max" step. DB2 does not need it.
                --     But other engines like PostgreSQL might.
                -- Aggregate by 'up'.
                AggrCell (lev, zoo, up, row, lft, rght, point) as (
                    select  lev, zoo, up,
                            row_number() over (
                                    partition by up
                                    order by zoo asc),
                            min(lft)   over (partition by up),
                            min(rght)  over (partition by up),
                            sum(point) over (partition by up)
                    from SuperCell
                )
            -- Pick first row from each partition group to represent
            -- the super-cell. Pour into the stratum reserve.
            select  case
                        when lft > rght then lft
                        else                 rght
                    end,     -- the level of this new tile
                    zoo,     -- its zoo
                    lev, -- its base level, where this cell was created
                    lft,    -- touches lft neighbour tile at this level
                    rght,   -- touches rght neighbour tile at this level
                    point   -- aggregated number of points in new tile
            from AggrCell
            where row = 1;

            stratum_ = stratum_ - 1;
        end loop;

        return 0;
    end;
$$ language plpgsql;

-- select popbystratum();
