
SELECT INITIALIZE_PI_CUBE();

SELECT CREATE_BASE_LAYER();
-- TIME: 29 sec (MBP 1 month yellow)
-- TIME:      yellow, 2015-2016, sparq

SELECT CREATE_XY_LAYER(2);
-- TIME 28 minutes (yellow full - qnap)
-- TIME 28 secs (yellow, 1 month, MBP)
-- TIME 32 secs (yellow, 2015-2016, sparq)

SELECT CREATE_UV_LAYER(2, 2);
-- TIME 23 secs (yel, 15-16, sparq)
SELECT CREATE_UV_LAYER(2, 3);
-- TIME 15 (y, 15-16, sparq)
select create_uv_layer(2, 4);
-- TIME 13 (y, 15-16, sparq)
select create_uv_layer(2, 5);
-- TIME 10 (y, 15-16, sparq)
select create_uv_layer(2, 6);
-- TIME 9 (y, 15-16, sparq)

SELECT CREATE_XY_LAYER(3);
-- TIME 32 secs (yellow, 2015-2016, sparq)

select create_uv_layer(3, 2);
select create_uv_layer(3, 3);
select create_uv_layer(3, 4);
select create_uv_layer(3, 5);
select create_uv_layer(3, 6);

SELECT CREATE_XY_LAYER(4);
-- TIME 42 secs (yellow, 2015-2016, sparq)

select create_uv_layer(4, 2);
select create_uv_layer(4, 3);
select create_uv_layer(4, 4);
select create_uv_layer(4, 5);
select create_uv_layer(4, 6);

SELECT CREATE_XY_LAYER(5);
-- TIME 47 (yellow, 2015-2016, sparq)

select create_uv_layer(5, 2);
select create_uv_layer(5, 3);
select create_uv_layer(5, 4);
select create_uv_layer(5, 5);
select create_uv_layer(5, 6);

SELECT CREATE_XY_LAYER(6);
-- TIME  (yellow, 2015-2016, sparq)

select create_uv_layer(6, 2);
select create_uv_layer(6, 3);
select create_uv_layer(6, 4);
select create_uv_layer(6, 5);
select create_uv_layer(6, 6);


select create_pt_layer(2, 2, 2);
select create_pt_layer(2, 2, 3);
select create_pt_layer(2, 2, 4);
select create_pt_layer(2, 2, 5);
select create_pt_layer(2, 2, 6);

select create_pt_layer(2, 3, 2);
select create_pt_layer(2, 3, 3);
select create_pt_layer(2, 3, 4);
select create_pt_layer(2, 3, 5);
select create_pt_layer(2, 3, 6);

select create_pt_layer(2, 4, 2);
select create_pt_layer(2, 4, 3);
select create_pt_layer(2, 4, 4);
select create_pt_layer(2, 4, 5);
select create_pt_layer(2, 4, 6);

select create_pt_layer(2, 5, 2);
select create_pt_layer(2, 5, 3);
select create_pt_layer(2, 5, 4);
select create_pt_layer(2, 5, 5);
select create_pt_layer(2, 5, 6);

select create_pt_layer(2, 6, 2);
select create_pt_layer(2, 6, 3);
select create_pt_layer(2, 6, 4);
select create_pt_layer(2, 6, 5);
select create_pt_layer(2, 6, 6);

----

select create_pt_layer(3, 2, 2);
select create_pt_layer(3, 2, 3);
select create_pt_layer(3, 2, 4);
select create_pt_layer(3, 2, 5);
select create_pt_layer(3, 2, 6);

select create_pt_layer(3, 3, 2);
select create_pt_layer(3, 3, 3);
select create_pt_layer(3, 3, 4);
select create_pt_layer(3, 3, 5);
select create_pt_layer(3, 3, 6);

select create_pt_layer(3, 4, 2);
select create_pt_layer(3, 4, 3);
select create_pt_layer(3, 4, 4);
select create_pt_layer(3, 4, 5);
select create_pt_layer(3, 4, 6);

select create_pt_layer(3, 5, 2);
select create_pt_layer(3, 5, 3);
select create_pt_layer(3, 5, 4);
select create_pt_layer(3, 5, 5);
select create_pt_layer(3, 5, 6);

select create_pt_layer(3, 6, 2);
select create_pt_layer(3, 6, 3);
select create_pt_layer(3, 6, 4);
select create_pt_layer(3, 6, 5);
select create_pt_layer(3, 6, 6);

select create_pt_layer(4, 6, 2);
select create_pt_layer(4, 6, 3);
select create_pt_layer(4, 6, 4);
select create_pt_layer(4, 6, 5);
select create_pt_layer(4, 6, 6);


select create_pt_layer(5, 6, 2);
select create_pt_layer(5, 6, 3);
select create_pt_layer(5, 6, 4);
select create_pt_layer(5, 6, 5);
select create_pt_layer(5, 6, 6);


select create_pt_layer(6, 6, 2);
select create_pt_layer(6, 6, 3);
select create_pt_layer(6, 6, 4);
select create_pt_layer(6, 6, 5);
select create_pt_layer(6, 6, 6);


select create_pt_layer(5, 6, 2);
select create_pt_layer(5, 6, 3);
select create_pt_layer(5, 6, 4);
select create_pt_layer(5, 6, 5);
select create_pt_layer(5, 6, 6);


-- STATS

select xy_layer, count(*) from pi_cube group by xy_layer;
-- TIME: 6 minutes

select xy_layer, uv_layer, pt_layer, count(xy_layer) from pi_cube where xy_layer > 1 group by xy_layer, uv_layer, pt_layer order by xy_layer, uv_layer, pt_layer;
