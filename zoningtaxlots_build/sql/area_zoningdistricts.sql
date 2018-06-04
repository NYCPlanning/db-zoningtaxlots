CREATE TABLE lotzoneper AS (
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
);