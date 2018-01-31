-- ===========================================================================
-- pipelined sum by partition
--     This is use of a user-defined aggregate function, but in an "inverted"
--     way to usual.  It aggregates over a composite type!  The composite
--     type is passing in the INT to add to the sum as well as a boolean
--     flag indicating whether the tuple is the start of a partition (and
--     thus the running sum needs to be reset).  Interestingly, we only
--     need an INT as internal state for the aggregate function.
--
--     This should be 100% pipelined.  There is no group by.  And all
--     order-by's are with respect to the same criterion: id asc.
-- ---------------------------------------------------------------------------
-- created  : 2017-07-31
-- authors  : parke godfrey
-- platform : PostgreSQL 9.6
-- ===========================================================================

-- ===========================================================================
-- define a rolling sum that restarts on partition boundaries
--    1. we use a composite type to pass in consisting of
--           - the measure (int) that we are summing, and
--           - a boolean flag that indicates the start of a partition
--    2. state function      : the accumulator
--    3. finish function     : provides the return value
--    4. agggregate function : the wrapper
-- ---------------------------------------------------------------------------
-- intRS : a composite type that has an int and a boolean flag

do $d$
begin
    if not exists (
            select 1
            from pg_type
            where typname = 'intrs' )
    then
        create type intRS as (
            accum   int,
            restart boolean
        );
    end if;
end
$d$;

-- ---------------------------------------------------------------------------
-- sumInt_by_part_state : accumulator function

drop function if exists
    sumInt_by_part_state(int, intRS)
    cascade;
create function sumInt_by_part_state(int, intRS)
returns int
language plpgsql
as $f$
    declare i alias for $1;
    declare a alias for $2;
    declare j int;
    begin
        if a.restart or i is null then
            j := a.accum;
        elsif a.accum is null then
            j := i;
        else
            j := a.accum + i;
        end if;
        return j;
    end
$f$;

-- ---------------------------------------------------------------------------
-- sumInt_by_part_final : returns the aggregate value

drop function if exists
    sumInt_by_part_final(int)
    cascade;
create function sumInt_by_part_final(int)
returns intRS
language sql
as $f$
    select cast(($1, false) as intRS);
$f$;

-- ---------------------------------------------------------------------------
-- sumInt_by_part : the aggregate function

drop aggregate if exists
    sumInt_by_part(intRS)
    cascade;
create aggregate sumInt_by_part(intRS) (
    sfunc     = sumInt_by_part_state,
    stype     = int,
    finalfunc = sumInt_by_part_final
);

-- ===========================================================================
-- create a trial table, populate it, and run a test query
-- ---------------------------------------------------------------------------
-- TABLE Trial

drop table if exists Trial;
create table Trial (
    id      int,
    grp     char(1),
    measure int
);

insert into Trial values
    (1, 'A',  2),
    (2, 'A',  3),
    (3, 'B',  5),
    (4, 'B',  7),
    (5, 'B', 11),
    (6, 'C', 13),
    (7, 'D', 17),
    (8, 'D', 19);

-- ---------------------------------------------------------------------------
-- pipeline sliging-window query that uses our agggregate function

with
    CellLeft (id, grp, measure, lft) as (
        select  id,
                grp,
                measure,
                coalesce(
                    max(grp) over (
                        order by id
                        rows between
                        1 preceding
                            and
                        1 preceding ),
                    '.' )
        from Trial
    ),
    CellStart(id, grp, measure, start) as (
        select  id,
                grp,
                measure,
                cast(
                    case
                    when grp = lft then 0
                    else                1
                    end
                as boolean)
        from CellLeft
    ),
    CellFlag(id, grp, flagged) as (
        select  id,
                grp,
                cast((measure, start) as intRS)
        from CellStart
    ),
    CellRun(id, grp, runningF) as (
        select  id,
                grp,
                sumInt_by_part(flagged)
                    over (partition by grp order by id)
        from CellFlag
    ),
    CellAggr(id, grp, running) as (
        select  id,
                grp,
                (runningF).accum
        from CellRun
    )
select id, grp, running
from CellAggr
order by id;

