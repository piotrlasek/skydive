-- Piotr Lasek (2016)
 
DROP PROCEDURE CREATE_PYRAMID;
CREATE PROCEDURE CREATE_PYRAMID(SPACE_LAYERS INT, TIME_LAYERS INT)
BEGIN
   DECLARE I INT;
   DECLARE J INT;

   -- Do clean up
   DELETE FROM cubed_pyramid WHERE space_layer > 0;
   
   -- Create a base layer
   CALL CREATE_BASE_LAYER();
   
   -- I = 2 => base layer's number
   SET I = 2;
   
   -- Do the rest...
   WHILE I <= SPACE_LAYERS DO
      CALL CREATE_SPACE_LAYER(I);
	  SET J = 2;
	  
      WHILE J <= TIME_LAYERS DO
	     CALL CREATE_TIME_LAYER(I, J);
         SET J = J + 1;
      END WHILE;
	  
	  SET I = I + 1;
   END WHILE;
   
END;

-- show pyramid's strata

-- SELECT MAX(space_layer), MAX(time_layer), COUNT(*) FROM cubed_pyramid GROUP BY space_layer, time_layer ORDER BY space_layer, time_layer;

-- CREATE INDEXES

CREATE INDEX i1 ON cubed_pyramid(space_layer);
CREATE INDEX i2 ON cubed_pyramid(time_layer);
CREATE INDEX i3 ON cubed_pyramid(time);
CREATE INDEX i4 ON cubed_pyramid(space_layer, time_layer);
CREATE INDEX i5 ON cubed_pyramid(time, space_layer, time_layer);
CREATE INDEX i6 ON cubed_pyramid(time, time_layer, space_layer);
CREATE INDEX i7 ON cubed_pyramid(space_layer, time_layer, time);
