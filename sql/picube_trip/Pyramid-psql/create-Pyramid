-- ===========================================================================
-- create-Pyramid : table schema "Pyramid" to hold the pyramid's "boxes"
--     (aggregated tuples)
-- 
-- parke godfrey
-- 2017-04-02
-- 2017-05-18 Postgresql (PL)
-- ---------------------------------------------------------------------------
-- Note that the primary-key declaration creates an index.
-- ===========================================================================

-- drop table if exists Pyramid cascade;

create table Pyramid (
    lev    smallint not null, -- level / stratum that this cell / tile is at
    zoo    bigint not null,   -- zoo : Z-order ordinal
    base   smallint,          -- level at which the tile is created
    lft    smallint,          -- level at which the tile touches left neighbour
    rght   smallint,          -- level at which the tile touches right neighbour
    point int,                -- aggr of number of points within tile
    constraint pyramidPK
        primary key (lev, zoo)
);
