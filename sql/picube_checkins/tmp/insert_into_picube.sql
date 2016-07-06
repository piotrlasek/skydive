DROP FUNCTION IF EXISTS CREATE_FIRST_LAYER() CASCADE;

CREATE OR REPLACE FUNCTION CREATE_FIRST_LAYER() RETURNS INTEGER AS $$

    DECLARE BASE_TILE_SIZE2 FLOAT;


    BEGIN
        INSERT INTO PI_CUBE
          SELECT
             1,
             1,
             CAST(TILE_X / BASE_TILE_SIZE2 AS BIGINT) AS TILE_X_GROUP,
             CAST(TILE_Y / BASE_TILE_SIZE2 AS BIGINT) AS TILE_Y_GROUP,
             CAST(TIME / BASE_TIME_INTERVAL AS INTEGER) AS TIME_GROUP,
             SUM(CNT) AS CNT,
             LOG10(SUM(CNT)) AS CNT_LOG
          FROM
             PI_CUBE 
          WHERE
             SPACE_LAYER = 0 AND TIME_LAYER = 0
          GROUP BY
             TILE_X_GROUP,
             TILE_Y_GROUP,
             TIME_GROUP
          HAVING CNT > 10;

          RETURN 0;
      END;
$$ LANGUAGE plpgsql;
