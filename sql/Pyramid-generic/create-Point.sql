-- ===========================================================================
-- create-Point.sql : table schema "Point" to hold raw data points
-- 
--  author: parke godfrey
-- created: 2017-03-31 ["create-Point"]
--    last: 2018-08-15
-- ---------------------------------------------------------------------------
-- 2018-08-15
--     Tweaked for Postgres. Original was for DB2.
--     changed zoo over to bit-string
-- ===========================================================================

create table Point (
    id     integer not null, -- to number the rows 0 ..,
                             -- just for inventory purposes
    zoo    bit(64) not null  -- "Zed-Order Ordinal": the Z-order value
                             -- of the point's position
);

