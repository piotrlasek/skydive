-- ===========================================================================
-- create-Pyramid.sql : table schema "Pyramid" to hold the pyramid's "boxes"
--     (aggregated tuples)
-- 
--  author: parke godfrey
-- created: 2017-04-02 ["create-Pyramid"]
--    last: 2018-08-15
-- ---------------------------------------------------------------------------
-- Note that the primary-key declaration creates an index.
-- ---------------------------------------------------------------------------
-- 2018-08-15
--     Tweaked for Postgres. Original was for DB2.
-- ===========================================================================

create table Pyramid (
    lev  smallint not null, -- level / stratum that this cell / tile is at
    zoo  bit(64)  not null, -- zoo : Z-order ordinal
    base smallint,          -- level at which the tile is created
    lft  smallint,          -- level at which the tile touches
                            -- left neighbour
    rght smallint,          -- level at which the tile touches
                            -- right neighbour
    pointCnt int,           -- aggr of number of points within tile
    constraint pyramidPK
        primary key (lev, zoo)
);

