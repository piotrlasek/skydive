-- ------------------------------------------------------------------
-- Piotr Lasek (2016)
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_PICUBE(SPACE_LAYERS INT, TIME_LAYERS INT);
-- ------------------------------------------------------------------
CREATE FUNCTION CREATE_PICUBE(SPACE_LAYERS INT, TIME_LAYERS INT) RETURNS INTEGER AS $$
    DECLARE I INT;
    DECLARE J INT;

    BEGIN
    -- Clean-up 
    DELETE FROM pi_cube WHERE space_layer > 0;

    -- Create a base layer
    RAISE NOTICE 'Creating base layer...';
    PERFORM CREATE_BASE_LAYER();
    --RAISE NOTICE 'Done.';

    -- I = 2 => base layer's number
    I = 2;

    -- Do the rest...
    <<space_layers_loop>>
    WHILE I <= SPACE_LAYERS LOOP
        RAISE NOTICE 'Creating space layer no. %', I;
        PERFORM CREATE_SPACE_LAYER(I);
        --RAISE NOTICE 'Done.';
        J = 2;

        <<time_layers_loop>>
        WHILE J <= TIME_LAYERS LOOP 
            RAISE NOTICE 'Crating time layer no. %', J;
            PERFORM CREATE_TIME_LAYER(I, J);
            --RAISE NOTICE 'Done.';
            J = J + 1;
        END LOOP time_layers_loop;

        I = I + 1;
    END LOOP space_layers_loop;

    RAISE NOTICE 'Done.';

    RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS CREATE_INDEXES();
-- ------------------------------------------------------------------
CREATE FUNCTION CREATE_INDEXES() RETURNS INTEGER AS $$
    BEGIN
        CREATE INDEX i1 ON pi_cube(space_layer);
        CREATE INDEX i2 ON pi_cube(time_layer);
        CREATE INDEX i3 ON pi_cube(time);
        CREATE INDEX i4 ON pi_cube(space_layer, time_layer);
        CREATE INDEX i5 ON pi_cube(time, space_layer, time_layer);
        CREATE INDEX i6 ON pi_cube(time, time_layer, space_layer);
        CREATE INDEX i7 ON pi_cube(space_layer, time_layer, time);
        RETURN 0;
    END;
$$ LANGUAGE plpgsql;

