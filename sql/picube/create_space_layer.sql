-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_SPACE_LAYER(SPACE_LAYER_NUM INT) CASCADE;
-- ------------------------------------------------------------------
CREATE FUNCTION CREATE_SPACE_LAYER(SPACE_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;
    BEGIN
        INSERT INTO
            CUBED_PYRAMID
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

        SELECT COUNT(*) FROM PI_CUBE
            WHERE SPACE_LAYER = SPACE_LAYER_NUM AND
            TIME_LAYER = 1 INTO RES;

        RETURN RES;
    END;
$$ LANGUAGE plpgsql;
