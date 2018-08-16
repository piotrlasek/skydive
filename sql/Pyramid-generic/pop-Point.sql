
insert into Point (id, zoo)
with
    recursive Row (id, zoo) as (
        select  0, randBitString(64)
        union all
        select  id + 1, randBitString(64)
        from Row
        where id < 10000000 - 1
    )
select id, zoo
from Row;

