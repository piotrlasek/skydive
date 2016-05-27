alter table checkins add column dayofweek integer;

UPDATE CHECKINS SET DAYOFWEEK = DAYOFWEEK(TIME);

create table pyramid as
SELECT
      0 AS LAYER,
      CAST((LONGITUDE - (SELECT MIN(LONGITUDE) FROM CHECKINS))* 1000000000 AS BIGINT) AS TILE_X,
      CAST((LATITUDE - (SELECT MIN(LATITUDE) FROM CHECKINS)) * 1000000000 AS BIGINT) AS TILE_Y,
      COUNT(USER_ID) AS COUNT_CODE,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 1) as mon,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 2) as tue,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 3) as wed,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 4) as thu,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 5) as fri,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 6) as sat,
      (select count_dow from tmp where tmp.lon = longitude and lat = latitude and dayofweek = 7) as sun
   FROM
      CHECKINS
   GROUP BY
      LONGITUDE,
      LATITUDE
   WITH DATA;

/**
 * Creates a table for storing the pyramid index and fills it with initial data.
 */
DROP TABLE PYRAMID CASCADE;
CREATE TABLE PYRAMID AS
   SELECT
      0 AS LAYER,
      CAST((LONGITUDE - (SELECT MIN(LONGITUDE) FROM CHECKINS))* 1000000000 AS BIGINT) AS TILE_X,
      CAST((LATITUDE - (SELECT MIN(LATITUDE) FROM CHECKINS)) * 1000000000 AS BIGINT) AS TILE_Y,
      COUNT(USER_ID) AS COUNT_CODE,
      ...
   FROM
      CHECKINS
   GROUP BY
      LONGITUDE,
      LATITUDE
   WITH DATA;

/**
 * Returns a size of a base tile.
 */
DROP FUNCTION GET_BASE_TILE_SIZE CASCADE;
CREATE FUNCTION GET_BASE_TILE_SIZE()
RETURNS FLOAT
BEGIN
   DECLARE MAX_X BIGINT;
   DECLARE MIN_X BIGINT;
   DECLARE BASE_TILE_SIZE FLOAT;

   SELECT MAX(TILE_X) INTO MAX_X FROM PYRAMID WHERE LAYER=0;
   SELECT MIN(TILE_X) INTO MIN_X FROM PYRAMID WHERE LAYER=0;
   SET BASE_TILE_SIZE = (MAX_X - MIN_X) / 512;

   RETURN BASE_TILE_SIZE;
END;

/**
 * Creates a first layer of the pyramid.
 * Returns a number of tuples in the first layer.
 */
DROP FUNCTION CREATE_FIRST_LAYER CASCADE;
CREATE FUNCTION CREATE_FIRST_LAYER()
RETURNS INTEGER
BEGIN
   DECLARE RESULT BIGINT;
   DECLARE LAYER_NUMBER INTEGER;
   SET LAYER_NUMBER = 1;
   DECLARE BASE_TILE_SIZE2 FLOAT;
   SET BASE_TILE_SIZE2 = GET_BASE_TILE_SIZE();

   INSERT INTO PYRAMID
      SELECT
         LAYER_NUMBER,
         CAST(TILE_X / BASE_TILE_SIZE2 AS BIGINT) AS TILE_X_GROUP,
         CAST(TILE_Y / BASE_TILE_SIZE2 AS BIGINT) AS TILE_Y_GROUP,
	 SUM(COUNT_CODE) AS COUNT_CODE,
         SUM(MON) AS MON,
         SUM(TUE) AS TUE,
         SUM(WED) AS WED,
         SUM(THU) AS THU,
         SUM(FRI) AS FRI,
         SUM(SAT) AS SAT,
         SUM(SUN) AS SAT
      FROM
         PYRAMID
      WHERE
         LAYER = LAYER_NUMBER - 1
      GROUP BY
         TILE_X_GROUP,
         TILE_Y_GROUP;

   SELECT COUNT(*) INTO RESULT FROM PYRAMID WHERE LAYER = LAYER_NUMBER;

   RETURN RESULT;
END;

/**
 * Creates a next layer of the pyramid.
 * Returns a number of tuples in the created layer.
 */
DROP FUNCTION CREATE_NEXT_LAYER CASCADE;
CREATE FUNCTION CREATE_NEXT_LAYER()
RETURNS INTEGER
BEGIN
   DECLARE RESULT BIGINT;
   DECLARE LAYER_NUMBER INTEGER;

   SELECT MAX(LAYER) INTO LAYER_NUMBER FROM PYRAMID;
   SET LAYER_NUMBER = LAYER_NUMBER + 1;

        INSERT INTO PYRAMID
                SELECT
                        LAYER_NUMBER,
                        CAST(TILE_X / 2 AS BIGINT) AS TILE_X_GROUP,
                        CAST(TILE_Y / 2 AS BIGINT) AS TILE_Y_GROUP,
                        SUM(COUNT_CODE) AS COUNT_CODE,
                        SUM(MON) AS MON,
                        SUM(TUE) AS TUE,
                        SUM(WED) AS WED,
                        SUM(THU) AS THU,
                        SUM(FRI) AS FRI,
                        SUM(SAT) AS SAT,
                        SUM(SUN) AS SAT

                FROM
                        PYRAMID
                WHERE
                        LAYER = LAYER_NUMBER - 1
                GROUP BY
                        TILE_X_GROUP,
                        TILE_Y_GROUP
        ;

        SELECT COUNT(*) INTO RESULT FROM PYRAMID WHERE LAYER = LAYER_NUMBER;

        RETURN RESULT;
END;


-- some extra changes

SELECT CREATE_FIRST_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();
SELECT CREATE_NEXT_LAYER();

ALTER TABLE PYRAMID ADD COLUMN COUNT_SQRT FLOAT;
UPDATE PYRAMID SET COUNT_SQRT = SQRT(COUNT_CODE);
