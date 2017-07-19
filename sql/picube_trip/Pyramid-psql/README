psql -U postgres -d islands

211 mln records / points

select popbase()		1900 sec.
select count(*) from pyramid	  12 sec.
55 mln
select popbystratum()		1127 sec.
83652699

postgres=# select base, count(*) from pyramid group by base order by base desc;
 base |  count
------+----------
   31 | 51190100
   30 |   222765
   29 |  8020728
   28 | 11291704
   27 |  7698993
   26 |  3830308
   25 |  1048576
   24 |   262144
   23 |    65536
   22 |    16384
   21 |     4096
   20 |     1024
   19 |      256
   18 |       64
   17 |       16
   16 |        4
   15 |        1


