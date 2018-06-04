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
WHERE p.bbl LIKE'2%' 
AND ST_GeometryType(ST_MakeValid(n.geom)) = 'ST_MultiPolygon'
)
SELECT bbl, zonedist, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM lotzoneper
);

WITH lotzoneperorder AS(
	SELECT bbl, zonedist, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM lotzoneper
  		WHERE pergeom <> '100')
	LEFT JOIN pluto_input_bsmtcode b
	ON x.bsmnt_type = b.bsmnt_type AND x.bsmntgradient = b.bsmntgradient
	WHERE x.row_number = 1)

UPDATE dcp_zoning_taxlot_edm a
SET zoningdistrict1 = zonedist
FROM lotzoneper b
WHERE pergeom = 100 AND a.bbl=b.bbl;

