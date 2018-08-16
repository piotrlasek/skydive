-- ===========================================================================
-- mk-Funct.sql : declare Zed-Order functions we will need

--  author: parke godfrey
-- created: 2017-03-31 [v0] ["mk-Funct"]
-- version: 2017-04-03 [v1]
-- authors: parke godfrey (PG), piotr lasek (PL)
--    last: 2017-05-03 [v3] ; ported to PostgreSQL (PL)
-- ===========================================================================

-- ===========================================================================
-- randBitString
--     len : length for the bit-string
-- ---------------------------------------------------------------------------

drop function if exists
randBitString(
    len integer
)
cascade;

create function
randBitString(
    len integer
)
returns bit varying as $$
begin
    return
        array_to_string(
            ARRAY(
                select chr((48 + floor(random()*2)) :: integer)
                from generate_series(1,len)
            ),
            ''
        ) :: bit varying;
end;
$$ language plpgsql;

-- ===========================================================================
-- adjAtLevel
--     dim     : the dimensionality of our zoo's
--     zooA    : one zoo as a bigint
--     zooB    : second zoo as a bigint (might be NULL)
-- returns the stratum / level in which the two zoo's are adjacent
-- ---------------------------------------------------------------------------

drop function if exists
adjAtLevel(
    dim  smallint,
    zooA bit varying,
    zooB bit varying
)
cascade;

create function
adjAtLevel (
    dim  smallint,
    zooA bit varying,
    zooB bit varying
)
returns smallint as $$
declare
    onePos smallint;
begin
    if (zooA is null or zooB is null) then
        return 0;
    end if;
    onePos := position('1' in (zooA # zooB));
    if (onePos = 0) then
        return floor(length(zooA) / dim) + 1;
    else
        return floor((onePos - 1) / dim) + 1;
    end if;
end;
$$ language plpgsql;

-- ===========================================================================
-- zooAtLevel
--     dim     : the dimensionality of our zoo's
--     level   : level we want the zoo "cut" to
--     zoo     : the zoo to "convert"
-- returns the zoo "converted" to represent tiles at level

drop function if exists
zooAtLevel(
    dim smallint,
    lev smallint,
    zoo bit varying
)
cascade;

create function
zooAtLevel(
    dim smallint,
    lev smallint,
    zoo bit varying
)
returns bit varying as $$
declare
    mask bit varying;
begin
    mask := (zoo | ~zoo) >> (dim * lev);
    return zoo & ~mask;
end;
$$ language plpgsql;

