-- ===========================================================================
-- create-Point.sql : table schema "Point" to hold raw data points
-- 
--  author: parke godfrey
-- created: 2017-03-31 ["create-Point"]
--    last: 2018-08-15
-- ---------------------------------------------------------------------------
-- 2018-08-15
--     Tweaked for Postgres. Original was for DB2.
-- ===========================================================================

create table Point (
    rowID  integer not null, -- to number the rows 0 ..,
                             -- just for inventory purposes
    zoo    bigint  not null  -- "Zed-Order Ordinal": the Z-order value
                             -- of the point's position
);

