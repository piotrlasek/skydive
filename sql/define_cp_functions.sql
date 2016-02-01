-- We probably have to introduce several types of pyramid dimensions.
-- In an example below we have one "two dimensional" space dimensional and
--  one time dimension.

-- data preparation
--
-- UPDATE
--  ch2
-- SET
--  s = (time - cast('2008-03-21 20:36:21.000000' as timestamp))/1000/60;

/*
 * Returns a size of a "spatial" base tile.
 */
DROP FUNCTION GET_BASE_TILE_SIZE CASCADE;
CREATE FUNCTION GET_BASE_TILE_SIZE()
RETURNS FLOAT
BEGIN
   DECLARE MAX_X BIGINT;
   DECLARE MIN_X BIGINT;
   DECLARE BASE_TILE_SIZE FLOAT;

   SELECT MAX(TILE_X) INTO MAX_X FROM CUBED_PYRAMID WHERE SPACE_LAYER=0;
   SELECT MIN(TILE_X) INTO MIN_X FROM CUBED_PYRAMID WHERE SPACE_LAYER=0;
   SET BASE_TILE_SIZE = (MAX_X - MIN_X) / 512;

   RETURN BASE_TILE_SIZE;
END;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_BASE_LAYER CASCADE;

/*
 * Creates a first/base layer of the pyramid - here base layer is denoted by 1.
 * Returns a number of tuples in the first layer.
 */
CREATE FUNCTION CREATE_BASE_LAYER()
RETURNS INTEGER
BEGIN
   DECLARE RESULT BIGINT;
   DECLARE BASE_TILE_SIZE2 FLOAT;
   SET BASE_TILE_SIZE2 = GET_BASE_TILE_SIZE();  -- initial tiling
   DECLARE BASE_TIME_INTERVAL INTEGER;
   SET BASE_TIME_INTERVAL = 3600;               -- one hour

   INSERT INTO CUBED_PYRAMID
      SELECT
         1,
         1,
         CAST(TILE_X / BASE_TILE_SIZE2 AS BIGINT) AS TILE_X_GROUP,
         CAST(TILE_Y / BASE_TILE_SIZE2 AS BIGINT) AS TILE_Y_GROUP,
         CAST(TIME / BASE_TIME_INTERVAL AS INTEGER) AS TIME_GROUP,
         SUM(CNT) AS CNT
      FROM
         CUBED_PYRAMID
      WHERE
         SPACE_LAYER = 0 AND
         TIME_LAYER = 0
      GROUP BY
         TILE_X_GROUP,
         TILE_Y_GROUP,
         TIME_GROUP;

   SELECT COUNT(*) INTO RESULT FROM CUBED_PYRAMID WHERE SPACE_LAYER = 1;

   RETURN RESULT;
END;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_SPACE_LAYER CASCADE;

/*
 * Creates a spatial layer of the pyramid.
 */
CREATE FUNCTION CREATE_SPACE_LAYER(SPACE_LAYER_NUM INT)
RETURNS INTEGER
BEGIN
   DECLARE RESULT BIGINT;

   INSERT INTO CUBED_PYRAMID
      SELECT
         SPACE_LAYER_NUM,
         1,
         CAST(TILE_X / 2 AS BIGINT) AS TILE_X_GROUP,
         CAST(TILE_Y / 2 AS BIGINT) AS TILE_Y_GROUP,
         TIME AS TIME_GROUP,
         SUM(CNT) AS CNT
      FROM
         CUBED_PYRAMID
      WHERE
         SPACE_LAYER = SPACE_LAYER_NUM - 1 AND
         TIME_LAYER = 1
      GROUP BY
         TILE_X_GROUP,
         TILE_Y_GROUP,
         TIME_GROUP;

   SELECT COUNT(*) INTO RESULT FROM CUBED_PYRAMID WHERE SPACE_LAYER = SPACE_LAYER_NUM AND TIME_LAYER = 1;

   RETURN RESULT;
END;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_TIME_LAYER CASCADE;

CREATE FUNCTION CREATE_TIME_LAYER(SPACE_LAYER_NUM INT, TIME_LAYER_NUM INT)
RETURNS INTEGER
BEGIN
DECLARE RESULT BIGINT;

INSERT INTO CUBED_PYRAMID
        SELECT
                SPACE_LAYER_NUM,
                TIME_LAYER_NUM,
                TILE_X AS TILE_X_GROUP,
                TILE_Y AS TILE_Y_GROUP,
                CAST(TIME / 2 AS INTEGER) AS TIME_GROUP,
                SUM(CNT) AS CNT
        FROM
                CUBED_PYRAMID
        WHERE
                SPACE_LAYER = SPACE_LAYER_NUM AND
                TIME_LAYER = TIME_LAYER_NUM - 1
        GROUP BY
                TILE_X_GROUP,
                TILE_Y_GROUP,
                TIME_GROUP;

        SELECT COUNT(*) INTO RESULT FROM CUBED_PYRAMID WHERE SPACE_LAYER = SPACE_LAYER_NUM AND TIME_LAYER = TIME_LAYER_NUM;

    RETURN RESULT;
END;
