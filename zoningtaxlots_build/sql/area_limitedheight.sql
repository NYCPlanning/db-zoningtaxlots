-- calculate how much (total area and percentage) of each lot is covered by a limited height district
-- assign the limited height district to each tax lot
-- the order limited height districts are assigned is based on which district covers the majority of the lot
-- a district is only assigned if more than 10% of the district covers the lot
-- OR more than a specified area of the lot if covered by the district

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
AND pergeom >= 10;

DROP TABLE limitedheightperorder;