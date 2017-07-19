-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     Definitions of functions used for creating
--                  a pi-cube.
-- ==================================================================

\timing on 

-- ------------------------------------------------------------------
-- Initialize pi_cube by removing "duplicates".
-- ------------------------------------------------------------------
-- DROP FUNCTION IF EXISTS INITIALIZE_PI_CUBE();
-- DROP TABLE IF EXISTS PI_CUBE;
\timing ON
--
CREATE OR REPLACE FUNCTION INITIALIZE_PI_CUBE() RETURNS INTEGER AS $$
    DECLARE MIN_LONGITUDE FLOAT;
    DECLARE MIN_LATITUDE FLOAT;
    DECLARE MIN_PICKUP_TIME TIMESTAMP;

    BEGIN
        RAISE NOTICE 'Initializing PI_CUBE table...';

        SELECT GET_MIN_LATITUDE() INTO MIN_LATITUDE;
        SELECT GET_MIN_LONGITUDE() INTO MIN_LONGITUDE;
        SELECT GET_MIN_PICKUP_TIME() INTO MIN_PICKUP_TIME;

        RAISE NOTICE 'Dropping PI_CUBE table if exists...';
        DROP TABLE IF EXISTS PI_CUBE CASCADE;

        RAISE NOTICE 'Creating PI_CUBE table';
        RAISE NOTICE '%', now();
		select now();
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
                SUM(TRIP_TIME) AS TT,
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
		select now();
        RAISE NOTICE '%', now();

        -- TIME: 2 hours 20 minutes (qnap)
		--       less than 30 sec (for one month on MBP)

        RAISE NOTICE 'Creating indexes on XY_LAYER';
        CREATE INDEX ON PI_CUBE(XY_LAYER);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating indexes on UV_LAYER';
        CREATE INDEX ON PI_CUBE(UV_LAYER);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating indexes on PT_LAYER';
        CREATE INDEX ON PI_CUBE(PT_LAYER);
        RAISE NOTICE '%', now();
        -- TIME: 20 mintes 
        
        RAISE NOTICE 'Creating index on X';
        CREATE INDEX ON PI_CUBE(X);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on Y';
        CREATE INDEX ON PI_CUBE(Y);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on U';
        CREATE INDEX ON PI_CUBE(U);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on V';
        CREATE INDEX ON PI_CUBE(V);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on PT';
        CREATE INDEX ON PI_CUBE(PT);
        RAISE NOTICE '%', now();
        -- TIME: 40 minutes

        RAISE NOTICE 'Creating index on (X, Y)';
        CREATE INDEX ON PI_CUBE(X, Y);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on (U, V)';
        CREATE INDEX ON PI_CUBE(U, V);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on (X, Y, PT)';
        CREATE INDEX ON PI_CUBE(X, Y, PT);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on (U, V, PT)';
        CREATE INDEX ON PI_CUBE(U, V, PT);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on (X, Y, U, V)';
        CREATE INDEX ON PI_CUBE(X, Y, U, V);
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Creating index on (X, Y, U, V, PT)';
        CREATE INDEX ON PI_CUBE(X, Y, U, V, PT);
        RAISE NOTICE '%', now();
        -- TIME: 
        RAISE NOTICE 'Done.';

        RETURN 0;
		
	-- Takes 3 minutes for 1 month on MBP.
        -- Takes 6 hours for two years (yellow taxi cab) on sparq.
        -- 12866 - 3.6 hours on sparq
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION INITIALIZE_POINT() RETURNS INTEGER AS $$
    DECLARE MIN_LONGITUDE FLOAT;
    DECLARE MIN_LATITUDE FLOAT;
    DECLARE MIN_PICKUP_TIME TIMESTAMP;

    BEGIN
        RAISE NOTICE 'Initializing POINT table...';

        SELECT GET_MIN_LATITUDE() INTO MIN_LATITUDE;
        SELECT GET_MIN_LONGITUDE() INTO MIN_LONGITUDE;
        -- SELECT GET_MIN_PICKUP_TIME() INTO MIN_PICKUP_TIME;

        RAISE NOTICE 'Dropping POINT table if exists...';
        DROP TABLE IF EXISTS POINT CASCADE;

        RAISE NOTICE 'Creating POINT table';
        RAISE NOTICE '%', now();
		
        CREATE TABLE POINT AS
            SELECT
                CAST((PICKUP_LONGITUDE - MIN_LONGITUDE) * 100000000 AS INT) AS X,
                CAST((PICKUP_LATITUDE - MIN_LATITUDE) * 100000000 AS INT) AS Y
                --CAST((DROPOFF_LONGITUDE - MIN_LONGITUDE) * 100000000 AS INT) AS U,
                --CAST((DROPOFF_LATITUDE - MIN_LATITUDE) * 100000000 AS INT) AS V,
                --EXTRACT(EPOCH FROM (PICKUP_DATETIME - MIN_PICKUP_TIME))::INTEGER AS PT,
                --SUM(TRIP_TIME) AS TT,
                --COUNT(*) AS CNT
            FROM
                DATA
            --GROUP BY
            --    PICKUP_LONGITUDE,
            --    PICKUP_LATITUDE
            -- [SELECT]
            WITH DATA;
		
        RAISE NOTICE '%', now();
        RAISE NOTICE 'Done.';
		
	--ALTER TABLE point ADD COLUMN zoo BIGINT;
	--UPDATE point SET zoo = st_morton(x, y);

        --RAISE NOTICE '%', now();

        -- TIME: 2 hours 20 minutes (qnap)
	--       less than 30 sec (for one month on MBP)
	--       4 minutes on sparq for 2 years for one month

	RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- ...
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_MIN_LONGITUDE() CASCADE;
CREATE OR REPLACE FUNCTION GET_MIN_LONGITUDE() RETURNS FLOAT AS $$
    DECLARE MIN_PICKUP_LONGITUDE FLOAT;
    DECLARE MIN_DROPOFF_LONGITUDE FLOAT;
    DECLARE MIN_LONGITUDE FLOAT;

    BEGIN
        RAISE NOTICE '%', now();
        RAISE NOTICE '   Selecting minimal longitude...';
        SELECT MIN(DROPOFF_LONGITUDE)
            FROM DATA INTO MIN_DROPOFF_LONGITUDE;
        
        IF MIN_PICKUP_LONGITUDE < MIN_DROPOFF_LONGITUDE THEN
            MIN_LONGITUDE := MIN_PICKUP_LONGITUDE;
        ELSE
            MIN_LONGITUDE := MIN_DROPOFF_LONGITUDE;
        END IF;

        RAISE NOTICE '%', now();
        RETURN MIN_LONGITUDE;
    END;

$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- ...
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_MIN_LATITUDE() CASCADE;
CREATE OR REPLACE FUNCTION GET_MIN_LATITUDE() RETURNS FLOAT AS $$
    DECLARE MIN_PICKUP_LATITUDE FLOAT;
    DECLARE MIN_DROPOFF_LATITUDE FLOAT;
    DECLARE MIN_LATITUDE FLOAT;

    BEGIN
        RAISE NOTICE '   Selecting minimal latitude...';
        RAISE NOTICE '%', now();
        SELECT MIN(PICKUP_LATITUDE)
            FROM DATA INTO MIN_PICKUP_LATITUDE;

        RAISE NOTICE '%', now();
        SELECT MIN(DROPOFF_LATITUDE)
            FROM DATA INTO MIN_DROPOFF_LATITUDE;

        RAISE NOTICE '%', now();
        IF MIN_PICKUP_LATITUDE < MIN_DROPOFF_LATITUDE THEN
            MIN_LATITUDE := MIN_PICKUP_LATITUDE;
        ELSE
            MIN_LATITUDE := MIN_DROPOFF_LATITUDE;
        END IF;
        RAISE NOTICE '%', now();

        RETURN MIN_LATITUDE;
    END;

$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- ...
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_MIN_PICKUP_TIME() CASCADE;
CREATE OR REPLACE FUNCTION GET_MIN_PICKUP_TIME() RETURNS TIMESTAMP AS $$
    DECLARE MIN_PICKUP_TIME TIMESTAMP;

    BEGIN
        RAISE NOTICE '   Selecting minimal pickup time...';
        RAISE NOTICE '%', now();
        SELECT MIN(PICKUP_DATETIME)
            FROM DATA INTO MIN_PICKUP_TIME;

        RAISE NOTICE '%', now();
        RETURN MIN_PICKUP_TIME;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
-- ...
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS GET_BASE_TILE_SIZE() CASCADE;
\timing on
-- 
CREATE OR REPLACE FUNCTION GET_BASE_TILE_SIZE() RETURNS FLOAT AS $$
    DECLARE MIN_X BIGINT;
    DECLARE MAX_X BIGINT;
    DECLARE BASE_TILE_SIZE FLOAT;
    DECLARE CELLS_PER_DIM INTEGER;

    BEGIN
        RAISE NOTICE '   Determining base tile size...';
        RAISE NOTICE '   Start: %', now();
        CELLS_PER_DIM = 1024;
        SELECT MAX(X) INTO MAX_X FROM PI_CUBE WHERE XY_LAYER = 0;
        RAISE NOTICE '%', now();
        SELECT MIN(X) INTO MIN_X FROM PI_CUBE WHERE XY_LAYER = 0;
        RAISE NOTICE '%', now();
        BASE_TILE_SIZE = (MAX_X - MIN_X) / CELLS_PER_DIM;
        RAISE NOTICE '   End  : %', now();
        RETURN BASE_TILE_SIZE;
    END;

    -- 1.5 hours for two 2015, 2016 yellow taxi cab on sparq !!!
$$ LANGUAGE plpgsql;

-- 19.05.2017 10:29:41
-- For some reason we had to rebuild all indexes on pi_cube.
-- reindex table pi_cube;
-- 12258 secs

-- ------------------------------------------------------------------
-- The function creates the base layer of the pi_cube.
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_BASE_LAYER() CASCADE;
\timing on
-- 
CREATE OR REPLACE FUNCTION CREATE_BASE_LAYER() RETURNS INTEGER AS $$
    DECLARE BASE_TILE_SIZE FLOAT;
    DECLARE BASE_TIME_INTERVAL INTEGER;
    BEGIN
        RAISE NOTICE '   Creating base layer...';
        RAISE NOTICE '   Start: %', now();
        BASE_TIME_INTERVAL = 60 * 60;               -- 60 = 1 minute
        SELECT GET_BASE_TILE_SIZE() INTO BASE_TILE_SIZE;
        RAISE NOTICE '   Base tile size: %', BASE_TILE_SIZE;
        RAISE NOTICE '%', now();
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

        RAISE NOTICE '   End  : %', now();
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- 

-- ------------------------------------------------------------------
-- Creates a spatial layer of the pyramid.
-- ------------------------------------------------------------------

DROP FUNCTION CREATE_XY_LAYER(XY_LAYER_NUM INT) CASCADE;

\timing on

CREATE OR REPLACE FUNCTION CREATE_XY_LAYER(XY_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;

    BEGIN
        RAISE NOTICE '%', now();
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
        RAISE NOTICE '%', now();
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- TIME: c.a. 10 - 12 secs

-- ------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------

DROP FUNCTION CREATE_UV_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT) CASCADE;

\timing on

CREATE OR REPLACE FUNCTION CREATE_UV_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;

    BEGIN
        RAISE NOTICE '%', now();
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
        RAISE NOTICE '%', now();
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------------------

DROP FUNCTION CREATE_PT_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT,
                                   PT_LAYER_NUM INT) CASCADE;

\timing on

CREATE OR REPLACE FUNCTION CREATE_PT_LAYER(XY_LAYER_NUM INT, UV_LAYER_NUM INT,
                                   PT_LAYER_NUM INT) RETURNS INTEGER AS $$
    DECLARE RESULT BIGINT;
    BEGIN
        RAISE NOTICE '%', now();
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
        RAISE NOTICE '%', now();
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------------------
