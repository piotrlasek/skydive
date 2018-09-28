
with recursive sample(n, a, b) as (
      values(1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint))
      union all
      select n+1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint) from sample where n < 100000
    ),
    
    bits as (
        select
            interlacebitstrings(
                array[cast(b as bit(32)),cast(a as bit(32))])
                    as z1
      from sample
     )
select
    'interlaced', count(*)
from bits
where z1 is not null;


with recursive sample(n, a, b) as (
      values(1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint))
      union all
      select n+1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint) from sample where n < 100000
    ),
    bits as (
        select
            cast(morton_enc(a, b) as bit(64))
                    as z2
      from sample
     )
select
    'mort_enc', count(*)
from bits
where z2 is not null;

--with recursive sample(n, a, b) as (
--      values(1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint))
--      union all
--      select n+1, cast(random() * (2^32 - 1) as bigint), cast(random() * (2^32 - 1) as bigint) from sample where n < 10000
--    ),
--    
--    bits as (
--        select
--            interlacebitstrings(
--                array[cast(b as bit(32)),cast(a as bit(32))])
--                    as z1,
---            cast(morton_enc(a, b) as bit(64))
--                    as z2
--      from sample
--     )
--select
--    *, case when z1 <> z2 then 0 else 1 end as same
--from bits
--where z1 <> z2;


--1010101010101010101010101010101010101010101010101010101010101110 
--0101010101010101010101010101010101010101010101010101010101011101
