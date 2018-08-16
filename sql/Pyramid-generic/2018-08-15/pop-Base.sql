-- ===========================================================================
-- pop-Base : populate table "Pyramid" with the transformed raw data
--     from table "Point".
--     This aggregates the data for the base stratum (although we do not
--     anticipate any two "points" will be in the same bin).
--     Then we move each base "box" up to the stratum / lev(el) where it
--     touches a neighbouring cell; that is, has a neighbour.
--     Note that no aggregating of boxes is done here, except for preparing
--     the "base".
-- 
--  author: parke godfrey
-- created: 2017-04-02 [v0]
-- authors: parke godfrey (PG), piotr lasek (PL)
--    last: 2017-05-19 ; ported to PostgreSQL (PL)
--                     ; popbase takes 116 secs on PL's MBP.
-- ===========================================================================

drop function if exists popbase();

create function popbase() returns int as $$
    declare dim_      smallint default  2;
    declare maxDepth_ smallint default 31;

    begin
        insert into Pyramid (lev, zoo, base, lft, rght, pointCnt)
        with
            -- group the raw data (Point) for "base" of pyramid
            Base (zoo, point) as (
                select zoo, count(*)
                from Point
                group by zoo
            ),
            -- left : at which level does this tile and
            --        the one left of it touch?
            -- right: at which level does this tile and
            --        the one right of it touch?
            Neighbour (zoo, lft, rght, point) as (
                select  zoo, adjAtLevel(dim_, maxDepth_, zoo,
                            max(zoo) over (
                                order by zoo asc
                                rows between 1 preceding
                                         and 1 preceding)
                            ),
                        adjAtLevel(dim_, maxDepth_, zoo,
                            max(zoo) over (
                                order by zoo asc
                                rows between 1 following
                                         and 1 following)
                            ),
                        point
                from Base
            ),
            -- ceiling: the level at which this tile touches a neighbour
            Ceiling (zoo, ceiling, lft, rght, point) as (
                select zoo,
                    case
                        when lft > rght then lft
                        else                 rght
                    end as ceiling,
                    lft, rght, point
                from Neighbour
            )
        select ceiling, zoo, maxDepth_, lft, rght, point
        from Ceiling;

        return 0;
    end;
$$ language plpgsql;

