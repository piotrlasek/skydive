-- ==================================================================
-- Author:          Piotr Lasek
-- Create date:     June 3, 2016
-- Description:     
-- ==================================================================

\timing on

INSERT INTO
    PI_CUBE
SELECT
    *
FROM
    CUBED_PYRAMID
WHERE
    SPACE_LAYER = 0 AND
    TIME_LAYER = 0;
