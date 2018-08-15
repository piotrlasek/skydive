
insert into Point (row, zoo)
with recursive
	Row (row, zoo) as (
		select row, zoo
		from (values (0, random() * power(cast((4) as bigint), 31)))
				as Start (row, zoo)
		union all
		select row + 1, random() * power(cast((4) as bigint), 31)
		from Row
		where row < 10000000 - 1
	)
select row, zoo
from Row;

-- Takes 19 sec. on MacBook Pro.
