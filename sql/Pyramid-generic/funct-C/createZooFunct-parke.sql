-- Clean up by dropping any old functions you have created in Postgres.
-- The signatures might be different, but get called because of matching.
-- To see in PSQL:
-- # \df public.*

-- copy and tailor as you need; this is for Parke's Mac's ENV.

-- ===========================================================================
-- firstBitSet
--     zoo : a bit-string
-- returns the first bit set in the string ("1") by position
-- Position count starts at "1"; zero is returned if no 1's in string zoo.
-- ---------------------------------------------------------------------------

drop function if exists
firstBitSet(
    dim  int,
    zooA bit varying,
    zooB bit varying
)
cascade;

create function
firstBitSet(bit varying)
returns int
    as '/Users/godfrey/Research/Project/DataTexture/GIT/skydive/sql/Pyramid-generic/funct-C/zoo-functions',
    'firstBitSet'
    language c
    strict;

-- ===========================================================================
-- adjAtLevel
--     dim     : the dimensionality of our zoo's
--     zooA    : one zoo as a bigint
--     zooB    : second zoo as a bigint (might be NULL)
-- returns the stratum / level in which the two zoo's are adjacent
-- ---------------------------------------------------------------------------

drop function if exists
adjAtLevel(
    dim  int,
    zooA bit varying,
    zooB bit varying
)
cascade;

create function
adjAtLevel(int, bit varying, bit varying)
returns int
    as '/Users/godfrey/Research/Project/DataTexture/GIT/skydive/sql/Pyramid-generic/funct-C/zoo-functions',
    'adjAtLevel'
    language c
    strict;

-- ===========================================================================
-- zooAtLevel
--     dim     : the dimensionality of our zoo's
--     level   : level we want the zoo "cut" to
--     zoo     : the zoo to "convert"
-- returns the zoo "converted" to represent tiles at level
-- ---------------------------------------------------------------------------

drop function if exists
zooAtLevel(
    dim   int,
    level int,
    zoo   bit varying
)
cascade;

create function
zooAtLevel(int, bit varying, bit varying)
returns int
    as '/Users/godfrey/Research/Project/DataTexture/GIT/skydive/sql/Pyramid-generic/funct-C/zoo-functions',
    'zooAtLevel'
    language c
    strict;

