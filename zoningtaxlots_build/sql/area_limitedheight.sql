DROP TABLE limitedheightperorder;
CREATE TABLE limitedheightperorder AS (
WITH 
limitedheightper AS (
SELECT p.bbl, n.lhlbl
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)/ST_Area(p.geom))*100 as pergeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_limitedheight AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, lhlbl, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM limitedheightper
);

UPDATE dcp_zoning_taxlot_edm a
SET limitedheightdistrict = lhlbl
FROM limitedheightperorder b
WHERE a.bbl=b.bbl AND row_number = 1;

DROP TABLE limitedheightperorder;