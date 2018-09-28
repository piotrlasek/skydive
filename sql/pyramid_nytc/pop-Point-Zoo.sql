\timing on

drop table if exists point;

create unlogged table point as                                    
select
    x, y, 
    cast(interlacebitstrings(array[cast(y as bit(32)), cast(x as bit(32))]) as bit(64)) as zoo
from point_xyuv;-- limit 10000000;


-- 10^6 -->    1:12
-- 10^7 -->   12:16 
-- 10^8 -->  
-- 10^9 -->   23:00



