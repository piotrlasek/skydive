
insert into Point (id, zoo)
with
    recursive Row (id, zoo) as (
        select  0,
                array_to_string(
                    ARRAY(
                        select chr((48 + floor(random()*2)) :: integer)
                        from generate_series(1,64)
                    ),
                    ''
                ) :: bit(64)
        union all
        select  id + 1,
                array_to_string(
                    ARRAY(
                        select chr((48 + floor(random()*2)) :: integer)
                        from generate_series(1,64)
                    ),
                    ''
                ) :: bit(64)
        from Row
        -- where id < 10000000 - 1
        where id < 100 - 1
    )
select id, zoo
from Row;

