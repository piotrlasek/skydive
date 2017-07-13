CREATE OR REPLACE FUNCTION st_morton (p_col int8, p_row int8)
 RETURNS int8
AS
$$
/*  this procedure calculates the Morton number of a cell
    at the given row and col[umn]  
    Written:  D.M. Mark, Jan 1984;
    Converted to Vax/VMS: July 1985
    Converted to PostgreSQL, Simon Greener, 2010
*/
DECLARE
   v_row          int8 := 0;
   v_col          int8 := 0;
   v_key          int8;
   v_level        int4;
   v_left_bit     int8;
   v_right_bit    int8;
   v_quadrant     int8;
BEGIN
   v_row   := p_row;
   v_col   := p_col;
   v_key   := 0;
   v_level := 0;
   WHILE ((v_row>0) OR (v_col>0)) LOOP
     /* Split off the row (left_bit) and column (right_bit) bits and
     then combine them to form a bit-pair representing the quadrant */
     v_left_bit  := v_row % 2;
     v_right_bit := v_col % 2;
     v_quadrant  := v_right_bit + 2*v_left_bit;
     v_key       := v_key + ( v_quadrant << (2*v_level) );
     /* row, column, and level are then modified before the loop continues */
     v_row := v_row / 2;
     v_col := v_col / 2;
     v_level := v_level + 1;
   END LOOP;
   RETURN (v_key);
END;
$$
  LANGUAGE 'plpgsql' IMMUTABLE;
