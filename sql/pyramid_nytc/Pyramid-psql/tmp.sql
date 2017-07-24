-- create table tab(i int, v float);

--insert into tab 
--with recursive tab2(i, v) as (
--    select i,   random()   from (values(0, 1)) as start(i,v)
--    union all 
--    select i+1, random() from tab2
--    where i < 100 - 1
--)
--select * from tab2;
-- update tab set v = round(cast((v) as numeric), 2);

