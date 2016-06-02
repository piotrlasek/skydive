-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_FIRST_LAYER() CASCADE;
-- ------------------------------------------------------------------
CREATE OR REPLACE FUNCTION CREATE_FIRST_LAYER() RETURNS INTEGER AS $$
    -- Internal variables
    DECLARE BASE_TILE_SIZE2 FLOAT;
    DECLARE LAYER_NUMBER INT;
    DECLARE RES BIGINT;
    DECLARE BASE_TIME_INTERVAL INTEGER;
    
    BEGIN
        BASE_TILE_SIZE2 = GET_BASE_TILE_SIZE();
        BASE_TIME_INTERVAL = 1440;               -- 1 day = 60 minutes * 24 h
        SELECT 1 INTO LAYER_NUMBER;

        -- Generating base layer of the pi-cube
        INSERT INTO PI_CUBE
          SELECT
             1,
             1,
             CAST(TILE_X / BASE_TILE_SIZE2 AS BIGINT) AS TILE_X_GROUP,
             CAST(TILE_Y / BASE_TILE_SIZE2 AS BIGINT) AS TILE_Y_GROUP,
             CAST(TIME / BASE_TIME_INTERVAL AS INTEGER) AS TIME_GROUP,
             SUM(CNT) AS CNT
          FROM
             PI_CUBE 
          WHERE
             SPACE_LAYER = 0 AND TIME_LAYER = 0
          GROUP BY
             TILE_X_GROUP,
             TILE_Y_GROUP,
             TIME_GROUP;

          -- Counting all just created tuples
          SELECT COUNT(*) FROM PI_CUBE WHERE SPACE_LAYER = 1 INTO RES;
          RETURN RES;
      END;
$$ LANGUAGE plpgsql;
