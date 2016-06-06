-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Definitions of functions used for creating
--                  a pi-cube.
-- ==================================================================

\timing on

-- 
-- Create
-- ------------------------------------------------------------------
-- Drop pi-cube table.
DROP TABLE IF EXISTS PI_CUBE CASCADE;

-- Create pi_cube table.
CREATE TABLE IF NOT EXISTS PI_CUBE (
    XY_LAYER INTEGER,
    UV_LAYER INTEGER,
    T_LAYER INTEGER,
    X BIGINT,
    Y BIGINT,
    U BIGINT,
    V BIGINT,
    T INTEGER,
    CNT BIGINT
);

-- ------------------------------------------------------------------
-- Initialize pyramid by removing "duplicates".
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS INITIALIZE_PI_CUBE;

CREATE FUNCTION INITIALIZE_PI_CUBE() RETURNS INTEGER AS $$
    DECLARE MIN_LONGITUDE INTEGER;
    DECLARE MIN_LATITUDE INTEGER;
    BEGIN
        SELECT MIN(LONGITUDE) FROM DATA INTO MIN_LONGITUDE;
        SELECT MIN(LATITUDE) FROM DATA INTO MIN_LATITUDE;

        CREATE TABLE PI_CUBE AS
        SELECT
              0 AS xy_layer, -- This is not a base space layer
              0 AS uv_layer, -- This is not a base time layer
              0 AS t_layer,
              CAST((PICKUP_LONGITUDE - MIN_LONGITUDE)* 1000000000 AS BIGINT) AS X,
              CAST((PICKUP_LATITUDE - MIN_LATITUDE) * 1000000000 AS BIGINT) AS Y,
              CAST((DROPOFF_LONGITUDE - MIN_LONGITUDE)* 1000000000 AS BIGINT) AS U,
              CAST((DROPOFF_LATITUDE - MIN_LATITUDE) * 1000000000 AS BIGINT) AS V,
              TRIP_TIME_IN_SECS AS T,
              COUNT(*) AS CNT
           FROM
              CH2 -- checkins table with auxiliary column S -- seconds
           GROUP BY
              LONGITUDE,
              LATITUDE,
              S -- TIME
           WITH DATA;
    END;
$$ LANGUAGE plpgsql;
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_BASE_TILE_SIZE() CASCADE;
-- 
CREATE OR REPLACE FUNCTION GET_BASE_TILE_SIZE() RETURNS FLOAT AS $$
    DECLARE MIN_X BIGINT;
    DECLARE MAX_X BIGINT;
    DECLARE BASE_TILE_SIZE FLOAT;

    BEGIN
       SELECT MAX(TILE_X) INTO MAX_X FROM PI_CUBE WHERE SPACE_LAYER=0;
       SELECT MIN(TILE_X) INTO MIN_X FROM PI_CUBE WHERE SPACE_LAYER=0;
       BASE_TILE_SIZE = (MAX_X - MIN_X) / 512;

       RETURN BASE_TILE_SIZE;
    END;

$$ LANGUAGE plpgsql;
-- ------------------------------------------------------------------

DROP TABLE CUBED_PYRAMID CASCADE;

/*
 * Initialize pyramid by removing "duplicates".
 */

CREATE TABLE CUBED_PYRAMID AS
SELECT
      0 AS SPACE_LAYER, -- This is not a base space layer
      0 AS TIME_LAYER, -- This is not a base time layer
      CAST((pickup_longitude - (SELECT MIN(pickup_longitude) FROM data2)) * 1000000000 AS BIGINT) AS TILE_X,
      CAST((pickup_latitude - (SELECT MIN(pickup_latitude) FROM data2)) * 1000000000 AS BIGINT) AS TILE_Y,
      pickup_datetime AS TILE_T, -- tile time
      COUNT(*) AS CNT,
	    -- LOG10(COUNT(*)) AS CNT_LOG
   FROM
      data2 -- checkins table with auxiliary column S -- seconds
   GROUP BY
      pickup_latitude,
      pickup_longitude,
      pickup_datetime -- TIME
   WITH DATA;

/*
 * Returns a size of a "spatial" base tile.
 */
DROP FUNCTION GET_BASE_TILE_SIZE CASCADE;

CREATE OR REPLACE FUNCTION GET_BASE_TILE_SIZE() RETURNS FLOAT AS $$
    DECLARE MAX_X BIGINT;
    DECLARE MIN_X BIGINT;
    DECLARE BASE_TILE_SIZE FLOAT;

  BEGIN
    SELECT MAX(TILE_X) INTO MAX_X FROM CUBED_PYRAMID WHERE SPACE_LAYER=0;
    SELECT MIN(TILE_X) INTO MIN_X FROM CUBED_PYRAMID WHERE SPACE_LAYER=0;
    SET BASE_TILE_SIZE = (MAX_X - MIN_X) / 512;

    RETURN BASE_TILE_SIZE;
  END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_BASE_LAYER CASCADE;

/*
 * Creates a first/base layer of the pyramid - here base layer is denoted by 1.
 * Returns a number of tuples in the first layer.
 */
CREATE PROCEDURE CREATE_BASE_LAYER()
BEGIN
   DECLARE RESULT BIGINT;
   DECLARE BASE_TILE_SIZE2 FLOAT;
   SET BASE_TILE_SIZE2 = GET_BASE_TILE_SIZE();  -- initial tiling
   DECLARE BASE_TIME_INTERVAL INTEGER;
   SET BASE_TIME_INTERVAL = 1440;               -- 1 day = 60 minutes * 24 h
   --SET BASE_TIME_INTERVAL = 10080;               -- 7 day = 8 * 60 minutes * 24 h

   INSERT INTO CUBED_PYRAMID
      SELECT
         1,
         1,
         CAST(TILE_X / BASE_TILE_SIZE2 AS BIGINT) AS TILE_X_GROUP,
         CAST(TILE_Y / BASE_TILE_SIZE2 AS BIGINT) AS TILE_Y_GROUP,
         CAST(TIME / BASE_TIME_INTERVAL AS INTEGER) AS TIME_GROUP,
         SUM(CNT) AS CNT,
		 LOG10(SUM(CNT)) AS CNT_LOG
      FROM
         CUBED_PYRAMID
      WHERE
         SPACE_LAYER = 0 AND
         TIME_LAYER = 0
      GROUP BY
         TILE_X_GROUP,
         TILE_Y_GROUP,
         TIME_GROUP;
END;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_SPACE_LAYER CASCADE;

/*
 * Creates a spatial layer of the pyramid.
 */
CREATE PROCEDURE CREATE_SPACE_LAYER(SPACE_LAYER_NUM INT)
BEGIN
   DECLARE RESULT BIGINT;

   INSERT INTO CUBED_PYRAMID
      SELECT
         SPACE_LAYER_NUM,
         1,
         CAST(TILE_X / 2 AS BIGINT) AS TILE_X_GROUP,
         CAST(TILE_Y / 2 AS BIGINT) AS TILE_Y_GROUP,
         TIME AS TIME_GROUP,
         SUM(CNT) AS CNT,
		 SUM(CNT_LOG) AS CNT_LOG
      FROM
         CUBED_PYRAMID
      WHERE
         SPACE_LAYER = SPACE_LAYER_NUM - 1 AND
         TIME_LAYER = 1
      GROUP BY
         TILE_X_GROUP,
         TILE_Y_GROUP,
         TIME_GROUP;
END;

-- ------------------------------------------------------------------------------------------

DROP PROCEDURE CREATE_TIME_LAYER CASCADE;

CREATE PROCEDURE CREATE_TIME_LAYER(SPACE_LAYER_NUM INT, TIME_LAYER_NUM INT)
BEGIN
INSERT INTO CUBED_PYRAMID
        SELECT
                SPACE_LAYER_NUM,
                TIME_LAYER_NUM,
                TILE_X AS TILE_X_GROUP,
                TILE_Y AS TILE_Y_GROUP,
                CAST(TIME / 2 AS INTEGER) AS TIME_GROUP,
                SUM(CNT) AS CNT,
				SUM(CNT_LOG) AS CNT_LOG
        FROM
                CUBED_PYRAMID
        WHERE
                SPACE_LAYER = SPACE_LAYER_NUM AND
                TIME_LAYER = TIME_LAYER_NUM - 1
        GROUP BY
                TILE_X_GROUP,
                TILE_Y_GROUP,
                TIME_GROUP;
END;

-- ------------------------------------------------------------------------------------------
