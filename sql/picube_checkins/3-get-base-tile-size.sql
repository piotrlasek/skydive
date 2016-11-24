﻿-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_BASE_TILE_SIZE() CASCADE;
-- ------------------------------------------------------------------
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
