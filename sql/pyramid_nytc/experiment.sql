
-- prepare the point table

-- size 1000


-- drop table if exists Point;

drop table if exists pyramid;

create function morton_enc(bigint, bigint) returns bigint as '/mnt/d/skydive/sql/pyramid_nytc/funcs', 'morton_enc' language c strict;

\i createZooFunct-parke-pl.sql
\i pop-Point-From-Data.sql
\i pop-Base.sql
\i pop-ByStratum.sql
\i create-Pyramid.sql

-- create unlogged table Point as
-- select x,y,zooa::bit(64) as zoo from data_xyuv;-- limit 100000000;

select now()
\i '/mnt/e/data_1bln.pg' -- 2.5 h

select * from data_1bln
select now();
select poppointfromdata(); -- 36 min for the full dataset
select now();
create index point_z_brin_idx on Point using brin(zoo);
select popbase();
select popbystratum();


SSD

calculating zoo values: 23 hours

                       popbase             popbystratum
1.2 * 10^9             3:52:27             3:16:19


HDD (ext. usb.)
				brinindex, Pyramid indexed, unlogged
				popbase       popbystratum
      10^6 		--
      10^7 		--
      10^8 		17:36         00:18:48
1.2 * 10^9 		



HDD (ext. usb.)
                with ind. on pyramid                 no index on pyramid                noindex, unlogged            brinindex, Pyramid indexed, unlogged
              popbase     popbystratum           popbase         popbystratum         popbase        popbystratum    popbase       popbystratum
      10^6    00:19       00:17                  --              --                   --             --              --
      10^7    06:06       08:09                  05:28           --                   04:13          --              --
      10^8    --          --                     --              --                   27:31          40:11           30:37         01:29:22
1.2 * 10^9    --          --                     --              --                   --             --              

HDD (internal)
              popbase     popbystratum
      10^6    00:23       00:19
      10^7    04:15       04:19
      10^8    ---
1.2 * 10^9    gave up after 9 hours
