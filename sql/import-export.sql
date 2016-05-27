-- export Monetdb databse to csv file

copy select * from "sys"."cubed_pyramid" into '/home/piotr/monet_cubed_pyramid.csv' delimiters ';'

-- create table in Postgresql

CREATE TABLE "cubed_pyramid" (
	"space_layer" INTEGER,
	"time_layer"  INTEGER,
	"tile_x"      BIGINT,
	"tile_y"      BIGINT,
	"time"        INTEGER,
	"cnt"         BIGINT,
	"cnt_log"     FLOAT 
);


COPY cubed_pyramid from '/home/piotr/monet_cubed_pyramid.csv' DELIMITER ';' CSV;
