DROP TABLE lotzoneper;
DROP TABLE lotzoneperorderbx;
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
      ) END)) pergeom
 FROM validdtm AS p 
   INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM lotzoneper
);

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict1 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND (pergeom >= 10);

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict2 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND (pergeom >= 10);

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict3 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 3
AND (pergeom >= 10);

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict4 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 4
AND (pergeom >= 10);

DROP TABLE lotzoneperorder;