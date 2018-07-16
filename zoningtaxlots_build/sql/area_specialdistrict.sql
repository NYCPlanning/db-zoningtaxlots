-- calculate how much (total area and percentage) of each lot is covered by a special purpose district
-- assign the special purpose district(s) to each tax lot
-- the order special purpose districts are assigned is based on which district covers the majority of the lot
-- a district is only assigned if more than 10% of the district covers the lot
-- OR more than a specified area of the lot if covered by the district

DROP TABLE specialpurposeperorder;
CREATE TABLE specialpurposeperorder AS (
WITH 
specialpurposeper AS (
SELECT p.bbl, n.sdlbl
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) as seggeom,
    ST_Area(p.geom) as allgeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_specialpurpose AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, sdlbl, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY seggeom DESC) AS row_number
  		FROM specialpurposeper
);

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict1 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND pergeom >= 10;

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict2 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND pergeom >= 10;

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict3 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl 
AND row_number = 3
AND pergeom >= 10;

DROP TABLE specialpurposeperorder;