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
      ) END)) as seggeom,
    ST_Area(p.geom) as allgeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_limitedheight AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, lhlbl, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY seggeom DESC) AS row_number
  		FROM limitedheightper
);

UPDATE dcp_zoning_taxlot_edm a
SET limitedheightdistrict = lhlbl
FROM limitedheightperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND (pergeom >= 10 OR seggeom > 000000002);

DROP TABLE limitedheightperorder;