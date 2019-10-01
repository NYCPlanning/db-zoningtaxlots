-- calculate how much (total area and percentage) of each lot is covered by a zoning district
-- assign the zoning district(s) to each tax lot
-- the order zoning districts are assigned is based on which district covers the majority of the lot
-- a district is only assigned if more than 10% of the district covers the lot
-- OR the majority of the district is within the lot
-- split and process by borough to improve processing time
-- join each of the boro tables into one table
DROP TABLE IF EXISTS lotzoneperorder;
CREATE TABLE lotzoneperorder AS (
  SELECT * FROM lotzoneperordermn
  UNION
  SELECT * FROM lotzoneperorderbx
  UNION
  SELECT * FROM lotzoneperorderbk
  UNION
  SELECT * FROM lotzoneperorderqn
  UNION
  SELECT * FROM lotzoneperordersi
);

-- drop each of the boro tables
DROP TABLE lotzoneperordermn;
DROP TABLE lotzoneperorderbx;
DROP TABLE lotzoneperorderbk;
DROP TABLE lotzoneperorderqn;
DROP TABLE lotzoneperordersi;
-- null out any existing values
-- UPDATE dcp_zoning_taxlot
-- SET zoningdistrict1 = NULL, 
--   zoningdistrict2 = NULL, 
--   zoningdistrict3 = NULL, 
--   zoningdistrict4 = NULL;

-- update each of zoning district fields
-- only say that a lot is within a zoning district if
-- more than 10% of the lot is coverd by the zoning district
-- or more than a specified area is covered by the district
UPDATE dcp_zoning_taxlot a
SET zoningdistrict1 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND perbblgeom >= 10;

UPDATE dcp_zoning_taxlot a
SET zoningdistrict2 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND perbblgeom >= 10;

UPDATE dcp_zoning_taxlot a
SET zoningdistrict3 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 3
AND perbblgeom >= 10;

UPDATE dcp_zoning_taxlot a
SET zoningdistrict4 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 4
AND perbblgeom >= 10;

--\copy (SELECT * FROM lotzoneperorder ORDER BY bbl) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/intermediate_lotzoneperorder.csv' DELIMITER ',' CSV HEADER;

-- drop the area table
--DROP TABLE lotzoneperorder;

-- for lots without a zoningdistrict1
-- assign the zoning district that is 
-- within 25 feet or 7 meters
-- DROP TABLE IF EXISTS lotzonedistance;
-- CREATE TABLE lotzonedistance AS (
-- WITH validdtm AS (
--   SELECT a.bbl, a.geom 
--   FROM dof_dtm a
--   WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' 
--   AND a.bbl IN (SELECT bbl FROM dcp_zoning_taxlot WHERE zoningdistrict1 IS NULL)),
-- validzones AS (
--   SELECT a.zonedist, a.geom 
--   FROM dcp_zoningdistricts a
--   WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon')
-- SELECT a.bbl, b.zonedist
-- FROM validdtm a, validzones b
-- WHERE ST_DWithin(a.geom::geography, b.geom::geography, 7));

-- UPDATE dcp_zoning_taxlot a
-- SET zoningdistrict1 = zonedist
-- FROM lotzonedistance b
-- WHERE a.bbl=b.bbl 
-- AND zoningdistrict1 IS NULL;


-- SELECT a.bbl, ST_MakeValid(a.geom), a.bbl::TEXT as geom 
-- FROM dof_dtm a
-- WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon';
