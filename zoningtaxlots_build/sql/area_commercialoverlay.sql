DROP TABLE commoverlayperorder;
CREATE TABLE commoverlayperorder AS (
WITH 
commoverlayper AS (
SELECT p.bbl, n.overlay
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)/ST_Area(p.geom))*100 as pergeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_commercialoverlay AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, overlay, pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY pergeom DESC) AS row_number
  		FROM commoverlayper
);

UPDATE dcp_zoning_taxlot_edm a
SET commercialoverlay1 = overlay
FROM commoverlayperorder b
WHERE a.bbl=b.bbl AND row_number = 1;

UPDATE dcp_zoning_taxlot_edm a
SET commercialoverlay2 = overlay
FROM commoverlayperorder b
WHERE a.bbl=b.bbl AND row_number = 2;

DROP TABLE commoverlayperorder;