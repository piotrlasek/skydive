-- ==================================================================
-- Author:          
-- Create date:     September 14, 2017
-- Description:     Retrieving data from pyramid
-- ==================================================================

-- APPROACH 1 / probe approach (small amount of holes)
-- ----------------------------------
-- - in memory matrix 16x16
-- - sweep through the matrix to figure out what the largest
--   grid aligned hole is.
-- - check for holes
-- - 1x1 hoes are truly empty --> ignore
-- - 2x2, 4x4, etc.. --> we have to check
-- - probe the database to see if we can pick something up

-- APPROACH 2 / range approach (large amount of holes)
-- ----------------------------------
-- - scan 16 x 16 at level 16
-- - scan at level 15
-- - if we get a tuple sitting on top of a hole from 16 then
--   we are filling the hole

-- - repeat until no holes remain

-- disadvantage: we are picking up tuples that we already have
-- on the other hand: we are reading the disc sequentially which
--                    should be very efficient

\timing on

-- 
--
-- 
create or replace function getwoi(zoo bigint, width smallint) returns integer as $$
declare
    matrix integer[][]
begin 
    RAISE NOTICE 'getwoi';

    for t in 

    end loop;

    return 0;
end;
$$ language plpgsql;

-- select getwoi(cast(123 as BIGINT), cast(2 as SMALLINT));























