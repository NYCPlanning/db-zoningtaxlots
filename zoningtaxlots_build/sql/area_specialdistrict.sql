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
      ) END)/ST_Area(p.geom))*100 as pergeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_specialpurpose AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, sdlbl, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM specialpurposeper
);

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict1 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl AND row_number = 1;

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict2 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl AND row_number = 2;

UPDATE dcp_zoning_taxlot_edm a
SET specialdistrict3 = sdlbl
FROM specialpurposeperorder b
WHERE a.bbl=b.bbl AND row_number = 3;

DROP TABLE specialpurposeperorder;