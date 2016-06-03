-- ------------------------------------------------------------------
-- Piotr Lasek (2016)
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_TIME_LAYER(SPACE_LAYER_NUM INT, TIME_LAYER_NUM INT) CASCADE;
-- ------------------------------------------------------------------
CREATE FUNCTION CREATE_TIME_LAYER(SPACE_LAYER_NUM INT, TIME_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;

    BEGIN
        INSERT INTO
            PI_CUBE
        SELECT
            SPACE_LAYER_NUM,
            TIME_LAYER_NUM,
            TILE_X AS TILE_X_GROUP,
            TILE_Y AS TILE_Y_GROUP,
            CAST(TIME / 2 AS INTEGER) TIME_GROUP,
            SUM(CNT) AS CNT,
            SUM(CNT_LOG) AS CNT_LOG
        FROM
            CUBED_PYRAMID
        WHERE
                SPACE_LAYER = SPACE_LAYER_NUM  AND
            TIME_LAYER = TIME_LAYER_NUM - 1
        GROUP BY
            TILE_X_GROUP,
            TILE_Y_GROUP,
            TIME_GROUP;

        SELECT COUNT(*) FROM PI_CUBE
            WHERE SPACE_LAYER = SPACE_LAYER_NUM AND
            TIME_LAYER = TIME_LAYER_NUM INTO RESULT;

        RETURN RESULT;
    END;
$$ LANGUAGE plpgsql;
