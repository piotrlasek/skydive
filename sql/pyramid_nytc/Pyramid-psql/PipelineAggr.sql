-- ===========================================================================
-- PipelineAggr : aggregate over partitions of variable sizes
--     in one stream pass
-- created  : 2017-07-27
-- authors  : Parke Godfrey
-- platform : DB2
-- ---------------------------------------------------------------------------
-- This shows that we can remove the need for the hardcoded case-statement
-- lookahead.  This never processes partition-by-partition explicitly.
-- The drawback here is that we carry a running sum, for instance, of #pts.
-- This could overflow when the table is very large.

-- PostgreSQL and DB2 (but not until the most recent v11!) allow for user-
-- defined aggregate functions (UDAs).  It might be possible to tailor-make
-- UDAs to handle our aggregation with this approach.
-- ---------------------------------------------------------------------------

-- ===========================================================================
-- TRIAL
-- ---------------------------------------------------------------------------
-- echo create table Trial;

drop table Trial;
create table Trial (
    id  integer,
    grp char(1),
    x   integer
);

-- ---------------------------------------------------------------------------
-- echo populate table Trial;

insert into Trial values
    ( 0, 'A',  2),
    ( 1, 'A',  3),
    ( 2, 'B',  5),
    ( 3, 'B',  7),
    ( 4, 'B', 11),
    ( 5, 'A', 13),
    ( 6, 'A', 17),
    ( 7, 'A', 19),
    ( 8, 'A', 23),
    ( 9, 'C', 29),
    (10, 'C', 31),
    (11, 'D', 37),
    (12, 'E', 41),
    (13, 'E', 43);

-- ---------------------------------------------------------------------------
echo run pipeline aggregation query;

with
    CellLeft (id, grp, grpR, x) as (
        select id, grp,
            coalesce(
                max(grp) over (
                    order by id
                    rows between
                        1 following
                        and
                        1 following ),
                '.' ),
            x
        from Trial
    ),
    CellStop (id, grp, stop, x) as (
        select id, grp,
            case
                when grp <> grpR then 1
                else                  0
            end,
            x
        from CellLeft
    ),
    CellPart (id, part#, grp, stop, x) as (
        select id,
            case
                when stop = 0 then 0
                else               id + 1
            end,
            grp,
            stop,
            x
        from CellStop
    ),
    CellGap (id, grp, stop, partL, x) as (
        select id, grp, stop,
            coalesce(
                max(part#) over (
                    order by id
                    rows between
                        unbounded preceding
                        and
                        1 preceding ),
                0 ),
            x
        from CellPart
    ),
    CellRunning (id, grp, stop, partL, runningX) as (
        select id, grp, stop, partL,
            coalesce(
                stop * sum(x) over (order by id),
                0 )
        from CellGap
    )
select id,
    id - partL + 1 as psize,
    runningX - 
        coalesce(
            max(runningX) over (
                order by id
                rows between
                    unbounded preceding
                    and
                    1 preceding ),
            0 ) as sumX
from CellRunning
where stop = 1
order by id;

