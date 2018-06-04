DROP TABLE lotzoneper;
DROP TABLE lotzoneperorder;
CREATE TABLE lotzoneperorder AS (
WITH lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)/ST_Area(p.geom))*100 as pergeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_zoningdistricts AS n 
    ON ST_Intersects(p.geom, n.geom)
WHERE ST_GeometryType(ST_MakeValid(n.geom)) = 'ST_MultiPolygon'
)
SELECT bbl, zonedist, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM lotzoneper
);

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict1 = zonedist
FROM lotzoneperorder b
WHERE pergeom = 100 AND a.bbl=b.bbl AND row_number = 1;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict2 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl AND row_number = 2;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict3 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl AND row_number = 3;

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict4 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl AND row_number = 4;
