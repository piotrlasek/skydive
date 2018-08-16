-- ===========================================================================
-- pop-byStratum-Max : after "pop-Base", finish populating table "Pyramid"
--     level by level (stratum by stratum) with aggreagted "boxes" (cells).
-- 
--  author: parke godfrey
-- created: 2017-04-04 [v0]
-- authors: parke godfrey (PG), piotr lasek (PL)
-- version: 2017-05-19 [v1] (PL) ; ported to Postgresql
--    last: 2018-08-14 (PG) ; changed zoo over to bit()
-- ---------------------------------------------------------------------------
-- Ran to test; this does not seem needed for Postgres's performance.
-- Use 'pop-byStramum".
-- ===========================================================================

drop function if exists
popbystratummax() cascade;

create function
popbystratummax()
returns int as $$
declare
    dim_      smallint default  2;
    maxDepth_ smallint default 32;
    stratum_  smallint;
begin
    stratum_ = (select max(lev) from Pyramid);
    RAISE NOTICE 'Level %.', stratum_;

    while stratum_ > 0 loop
        insert into Pyramid(lev, zoo, base, lft, rght, pointCnt)
        with
            -- Select out all cells at level stratum_,
            -- add zoo ("up") for super-cell.
            SuperCell (lev, zoo, up, lft, rght, pointCnt) as (
                select
                    lev, zoo,
                    zooAtLevel(
                        dim_,
                        (stratum_ - 1)::smallint,
                        zoo
                    ),
                    lft, rght, pointCnt
                from Pyramid
                where lev = stratum_
            ),
			-- rectify order by max:
			-- This will seem crazy, but there is a method to our madness.
			-- We use a window aggregation to "replace" super with the max
			-- from begining of the list, which results in _very_ same value.
			-- But now the Optimizer knows the order is the same as for zoo!
			Upper (lev, zoo, up, lft, rght, pointCnt) as (
				select  lev, zoo,
						(max(up::text) over (
							order by zoo asc
							rows between unbounded preceding and current row
						) )::bit varying,
						lft, rght, pointCnt
				from SuperCell
			),
            -- Aggregate by 'up'.
            AggrCell (lev, zoo, up, row, lft, rght, pointCnt) as (
                select  lev, zoo, up,
                        row_number() over (
                                partition by up
                                order by zoo asc),
                        min(lft)      over (partition by up),
                        min(rght)     over (partition by up),
                        sum(pointCnt) over (partition by up)
                from Upper
            )
        -- Pick first row from each partition group to represent
        -- the super-cell. Pour into the stratum reserve.
        select  case
                    when lft > rght then lft
                    else                 rght
                end,     -- the level of this new tile
                zoo,     -- its zoo
                lev,     -- its base level, where this cell was created
                lft,     -- touches lft neighbour tile at this level
                rght,    -- touches rght neighbour tile at this level
                pointCnt -- aggregated number of points in new tile
        from AggrCell
        where row = 1;

        stratum_ = stratum_ - 1;
    end loop;

    return 0;
end;
$$ language plpgsql;

