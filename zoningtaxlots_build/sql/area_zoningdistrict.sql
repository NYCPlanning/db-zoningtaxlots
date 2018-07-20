-- create index on DTM and zoning districts
DROP INDEX dof_dtm_gix;
DROP INDEX dcp_zoningdistricts_gix;
CREATE INDEX dof_dtm_gix ON dof_dtm USING GIST (geom);
CREATE INDEX dcp_zoningdistricts_gix ON dcp_zoningdistricts USING GIST (geom);

-- calculate how much (total area and percentage) of each lot is covered by a zoning district
-- assign the zoning district(s) to each tax lot
-- the order zoning districts are assigned is based on which district covers the majority of the lot
-- a district is only assigned if more than 10% of the district covers the lot
-- OR more than a specified area of the lot if covered by the district
-- split and process by borough to improve processing time

DROP TABLE IF EXISTS lotzoneperordermn;
CREATE TABLE lotzoneperordermn AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM dof_dtm a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '1%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) seggeom,
     ST_Area(p.geom) as allgeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY seggeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderbx;
CREATE TABLE lotzoneperorderbx AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM dof_dtm a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '2%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) seggeom,
     ST_Area(p.geom) as allgeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY seggeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderbk;
CREATE TABLE lotzoneperorderbk AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM dof_dtm a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '3%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) seggeom,
     ST_Area(p.geom) as allgeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY seggeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderqn;
CREATE TABLE lotzoneperorderqn AS (
WITH validdtm AS (
  SELECT a.bbl, ST_ForceRHR(ST_MakeValid(a.geom)) as geom
  FROM dof_dtm a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '4%'),
validzones AS (
  SELECT a.zonedist, ST_ForceRHR(ST_MakeValid(a.geom)) as geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) seggeom,
     ST_Area(p.geom) as allgeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY seggeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperordersi;
CREATE TABLE lotzoneperordersi AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM dof_dtm a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '5%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) seggeom,
     ST_Area(p.geom) as allgeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY seggeom DESC) AS row_number
      FROM lotzoneper
);

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
UPDATE dcp_zoning_taxlot_edm
SET zoningdistrict1 = NULL, 
  zoningdistrict2 = NULL, 
  zoningdistrict3 = NULL, 
  zoningdistrict4 = NULL;

-- update each of zoning district fields
-- only say that a lot is within a zoning district if
-- more than 10% of the lot is coverd by the zoning district
-- or more than a specified area is covered by the district
UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict1 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND pergeom >= 10;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict2 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND pergeom >= 10;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict3 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 3
AND pergeom >= 10;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict4 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 4
AND pergeom >= 10;

-- drop the area table
DROP TABLE lotzoneperorder;