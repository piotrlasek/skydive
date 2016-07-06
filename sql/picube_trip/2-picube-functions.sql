-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Definitions of functions used for creating
--                  a pi-cube.
-- ==================================================================

\TIMING ON

-- ------------------------------------------------------------------
-- Initialize pi_cube by removing "duplicates".
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS INITIALIZE_PI_CUBE();
DROP TABLE IF EXISTS PI_CUBE;
\TIMING ON
--
CREATE FUNCTION INITIALIZE_PI_CUBE() RETURNS INTEGER AS $$
    DECLARE MIN_LONGITUDE FLOAT;
    DECLARE MIN_LATITUDE FLOAT;
    DECLARE MIN_PICKUP_TIME TIMESTAMP;
    
    BEGIN
        RAISE NOTICE 'Initializing PI_CUBE table...';

        RAISE NOTICE 'Selecting minimal PICKUP_LONGITUDE';
        SELECT MIN(PICKUP_LONGITUDE)
            FROM DATA INTO MIN_LONGITUDE;

        RAISE NOTICE 'Selecting minimal PICKUP_LATITUDE';
        SELECT MIN(PICKUP_LATITUDE)
            FROM DATA INTO MIN_LATITUDE;

        RAISE NOTICE 'Selecting minimal PICKUP_DATETIME';
        SELECT MIN(PICKUP_DATETIME)
            FROM DATA INTO MIN_PICKUP_TIME;

        RAISE NOTICE 'Dropping PI_CUBE table';
        DROP TABLE IF EXISTS PI_CUBE CASCADE;

        RAISE NOTICE 'Creating PI_CUBE table';
        CREATE TABLE PI_CUBE AS
            SELECT
                0 AS XY_LAYER, -- xy layer
                0 AS UV_LAYER, -- uv layer
                0 AS PT_LAYER, -- pickup time
                CAST((PICKUP_LONGITUDE - MIN_LONGITUDE) * 1000000000 AS BIGINT) AS X,
                CAST((PICKUP_LATITUDE - MIN_LATITUDE) * 1000000000 AS BIGINT) AS Y,
                CAST((DROPOFF_LONGITUDE - MIN_LONGITUDE) * 1000000000 AS BIGINT) AS U,
                CAST((DROPOFF_LATITUDE - MIN_LATITUDE) * 1000000000 AS BIGINT) AS V,
                EXTRACT(EPOCH FROM (PICKUP_DATETIME - MIN_PICKUP_TIME))::INTEGER AS PT,
                SUM(TRIP_TIME_IN_SECS) AS TT,
                COUNT(*) AS CNT
            FROM
                DATA
            GROUP BY
                PICKUP_LONGITUDE,
                PICKUP_LATITUDE,
                DROPOFF_LONGITUDE,
                DROPOFF_LATITUDE,
                PICKUP_DATETIME 
            -- [SELECT]
            WITH DATA;

        -- TIME: 2 hours 20 minutes

        RAISE NOTICE 'Creating indexes on XY_LAYER';
        CREATE INDEX ON PI_CUBE(XY_LAYER);
        RAISE NOTICE 'Creating indexes on UV_LAYER';
        CREATE INDEX ON PI_CUBE(UV_LAYER);
        RAISE NOTICE 'Creating indexes on PT_LAYER';
        CREATE INDEX ON PI_CUBE(PT_LAYER);
        -- TIME: 20 mintes 
        
        RAISE NOTICE 'Creating index on X';
        CREATE INDEX ON PI_CUBE(X);
        RAISE NOTICE 'Creating index on Y';
        CREATE INDEX ON PI_CUBE(Y);
        RAISE NOTICE 'Creating index on U';
        CREATE INDEX ON PI_CUBE(U);
        RAISE NOTICE 'Creating index on V';
        CREATE INDEX ON PI_CUBE(V);
        RAISE NOTICE 'Creating index on PT';
        CREATE INDEX ON PI_CUBE(PT);
        -- TIME: 40 minutes

        RAISE NOTICE 'Creating index on (X, Y)';
        CREATE INDEX ON PI_CUBE(X, Y);
        RAISE NOTICE 'Creating index on (U, V)';
        CREATE INDEX ON PI_CUBE(U, V);
        RAISE NOTICE 'Creating index on (X, Y, PT)';
        CREATE INDEX ON PI_CUBE(X, Y, PT);
        RAISE NOTICE 'Creating index on (U, V, PT)';
        CREATE INDEX ON PI_CUBE(U, V, PT);
        RAISE NOTICE 'Creating index on (X, Y, U, V)';
        CREATE INDEX ON PI_CUBE(X, Y, U, V);
        RAISE NOTICE 'Creating index on (X, Y, U, V, PT)';
        CREATE INDEX ON PI_CUBE(X, Y, U, V, PT);
        -- TIME: 
        RAISE NOTICE 'Done.';

        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- ...
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_BASE_TILE_SIZE() CASCADE;
\TIMING ON
-- 
CREATE OR REPLACE FUNCTION GET_BASE_TILE_SIZE() RETURNS FLOAT AS $$
    DECLARE MIN_X BIGINT;
    DECLARE MAX_X BIGINT;
    DECLARE BASE_TILE_SIZE FLOAT;
    DECLARE CELLS_PER_DIM INTEGER;

    BEGIN
        CELLS_PER_DIM = 1024;
        SELECT MAX(X) INTO MAX_X FROM PI_CUBE WHERE XY_LAYER = 0;
        SELECT MIN(X) INTO MIN_X FROM PI_CUBE WHERE XY_LAYER = 0;
        BASE_TILE_SIZE = (MAX_X - MIN_X) / CELLS_PER_DIM;

        RETURN BASE_TILE_SIZE;
    END;

$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- The function creates the base layer of the pi_cube.
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_BASE_LAYER() CASCADE;
\timing on
-- 
CREATE FUNCTION CREATE_BASE_LAYER() RETURNS INTEGER AS $$
    DECLARE BASE_TILE_SIZE FLOAT;
    DECLARE BASE_TIME_INTERVAL INTEGER;

    BEGIN
        BASE_TIME_INTERVAL = 60 * 60;               -- 60 = 1 minute
        SELECT GET_BASE_TILE_SIZE() INTO BASE_TILE_SIZE;

        INSERT INTO PI_CUBE 
            SELECT
                1, -- XY_LAYER, 2-D
                1, -- UV_LAYER, 2-D
                1, -- PT_LAYER, 1-D, pickup time layer
                CAST(X / BASE_TILE_SIZE AS BIGINT)      AS X_GROUP,
                CAST(Y / BASE_TILE_SIZE AS BIGINT)      AS Y_GROUP,
                CAST(U / BASE_TILE_SIZE AS BIGINT)      AS U_GROUP,
                CAST(V / BASE_TILE_SIZE AS BIGINT)      AS V_GROUP,
                CAST(PT / BASE_TIME_INTERVAL AS INTEGER) AS PT_GROUP,
                SUM(TT) AS TT,
                SUM(CNT) AS CNT
            FROM
                PI_CUBE 
            WHERE
                XY_LAYER = 0 AND
                UV_LAYER = 0 AND
                PT_LAYER = 0
            GROUP BY
                X_GROUP,
                Y_GROUP,
                U_GROUP,
                V_GROUP,
                PT_GROUP; -- in total: 5 dimensions

        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- Creates a spatial layer of the pyramid.
-- ------------------------------------------------------------------

DROP FUNCTION CREATE_XY_LAYER(XY_LAYER_NUM INT) CASCADE;

\timing on

CREATE FUNCTION CREATE_XY_LAYER(XY_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;

    BEGIN
        INSERT INTO PI_CUBE 
            SELECT
                XY_LAYER_NUM,   -- XY_LAYER
                1,              -- UV_LAYER
                1,              -- PT_LAYER
                CAST(X / 2 AS BIGINT) AS X_GROUP,
                CAST(Y / 2 AS BIGINT) AS Y_GROUP,
                U AS U_GROUP,
                V AS V_GROUP,
                PT AS PT_GROUP,
                SUM(TT) AS TT,
                SUM(CNT) AS CNT
            FROM
                PI_CUBE
            WHERE
                XY_LAYER = XY_LAYER_NUM - 1 AND
                UV_LAYER = 1 AND
                PT_LAYER = 1
            GROUP BY
                X_GROUP,
                Y_GROUP,
                U_GROUP,
                V_GROUP,
                PT_GROUP;
            RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- TIME: c.a. 10 - 12 secs

-- ------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------

DROP FUNCTION CREATE_UV_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT) CASCADE;

\timing on

CREATE FUNCTION CREATE_UV_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;

    BEGIN
        INSERT INTO PI_CUBE 
            SELECT
                XY_LAYER_NUM,   -- XY_LAYER
                UV_LAYER_NUM,   -- UV_LAYER
                1,              -- PT_LAYER
                X AS X_GROUP,
                Y AS Y_GROUP,
                CAST(U / 2 AS BIGINT) AS U_GROUP,
                CAST(V / 2 AS BIGINT) AS V_GROUP,
                PT AS PT_GROUP,
                SUM(TT) AS TT,
                SUM(CNT) AS CNT
            FROM
                PI_CUBE
            WHERE
                XY_LAYER = XY_LAYER_NUM AND
                UV_LAYER = UV_LAYER_NUM - 1 AND
                PT_LAYER = 1
            GROUP BY
                X_GROUP,
                Y_GROUP,
                U_GROUP,
                V_GROUP,
                PT_GROUP;
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_PT_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT,
                                   PT_LAYER_NUM INT) CASCADE;

\timing on

CREATE FUNCTION CREATE_PT_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT,
                                   PT_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;
    BEGIN
        INSERT INTO PI_CUBE 
            SELECT
                XY_LAYER_NUM,   -- XY_LAYER
                UV_LAYER_NUM,   -- UV_LAYER
                PT_LAYER_NUM,   -- PT_LAYER
                X AS X_GROUP,
                Y AS Y_GROUP,
                U AS U_GROUP,
                V AS V_GROUP,
                CAST(PT / 2 AS BIGINT) AS PT_GROUP,
                SUM(TT) AS TT,
                SUM(CNT) AS CNT
            FROM
                PI_CUBE
            WHERE
                XY_LAYER = XY_LAYER_NUM AND
                UV_LAYER = UV_LAYER_NUM  AND
                PT_LAYER = PT_LAYER_NUM - 1
            GROUP BY
                X_GROUP,
                Y_GROUP,
                U_GROUP,
                V_GROUP,
                PT_GROUP;
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------------------


select create_xy_layer(2);
-- TIME 28 minutes

select create_uv_layer(2, 2);
select create_uv_layer(2, 3);
select create_uv_layer(2, 4);
select create_uv_layer(2, 5);
select create_uv_layer(2, 6);

select create_uv_layer(3, 2);
select create_uv_layer(3, 3);
select create_uv_layer(3, 4);
select create_uv_layer(3, 5);
select create_uv_layer(3, 6);

select create_uv_layer(4, 2);
select create_uv_layer(4, 3);
select create_uv_layer(4, 4);
select create_uv_layer(4, 5);
select create_uv_layer(4, 6);

select create_uv_layer(5, 2);
select create_uv_layer(5, 3);
select create_uv_layer(5, 4);
select create_uv_layer(5, 5);
select create_uv_layer(5, 6);

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



select xy_layer, uv_layer, pt_layer, count(xy_layer) from pi_cube where xy_layer > 1 group by xy_layer, uv_layer, pt_layer order by xy_layer, uv_layer, pt_layer;
