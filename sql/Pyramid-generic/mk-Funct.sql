-- ===========================================================================
-- mk-Funct.sql : declare Zed-Order functions we will need

--  author: parke godfrey
-- created: 2017-03-31 [v0] ["mk-Funct"]
-- version: 2017-04-03 [v1]
-- authors: parke godfrey (PG), piotr lasek (PL)
-- version: 2017-05-03 [v2] ; ported to PostgreSQL (PL)
--    last: 2017-08-16 [v3] ; redone for bit-strings, added functs
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
-- interlaceBitStrings
--     bitstrs bit varying [] -- array of bit-strings
-- ---------------------------------------------------------------------------

drop function if exists
interlaceBitStrings(
    bitstrs bit varying []
)
cascade;

create function
interlaceBitStrings(
    bitstrs bit varying []
)
returns bit varying as $$
declare
    laced  bit varying default B'';
    head   bit(1);
    alen   integer;
    blen   integer;
    a      integer     default 1;
    b      integer     default 1;
begin
    alen := array_length(bitstrs, 1);
    blen := length(bitstrs[1]);
    while b <= blen loop
        a := 1;
        while a <= alen loop
            head       := bitstrs[a]::bit(1); -- pulls off first bit
            bitstrs[a] := bitstrs[a] << 1;    -- shift bit off
            laced      := laced || head;      -- appends at end
            a          := a + 1;              -- advance array counter
        end loop;
        b := b + 1; -- advance bit counter
    end loop;
    return laced;
end;
$$ language plpgsql;

-- ===========================================================================
-- unlaceBitString
--     dim    integer
--     bitstr bit varying
-- ---------------------------------------------------------------------------

drop function if exists
unlaceBitString(
    dim    integer,
    bitstr bit varying
)
cascade;

create function
unlaceBitString(
    dim    integer,
    bitstr bit varying
)
returns bit varying [] as $$
declare
    unlaced bit varying [];
    head    bit(1);
    blen    integer;
    a       integer  default 1;
    b       integer  default 1;
begin
    while a <= dim loop
        unlaced := unlaced || B''::bit varying;
        a := a + 1;
    end loop;

    blen := length(bitstr) / dim;
    while b <= blen loop
        a := 1;
        while a <= dim loop
            head       := bitstr::bit(1);     -- pulls off first bit
            bitstr     := bitstr << 1;        -- shift bit off
            unlaced[a] := unlaced[a] || head; -- append bit
            a := a + 1;
        end loop;
        b := b + 1;
    end loop;

    return unlaced;
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

