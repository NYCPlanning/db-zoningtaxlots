DROP TABLE commoverlayperorder;
CREATE TABLE commoverlayperorder AS (
WITH 
commoverlayper AS (
SELECT p.bbl, n.overlay, 
  (ST_Area(CASE 
    WHEN ST_CoveredBy(p.geom, n.geom) 
    THEN p.geom 
    ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) 
    END)) as seggeom,
  ST_Area(p.geom) as allgeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_commercialoverlay AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, overlay, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY seggeom DESC) AS row_number
  		FROM commoverlayper
);

UPDATE dcp_zoning_taxlot_edm a
SET commercialoverlay1 = overlay
FROM commoverlayperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND (pergeom >= 10 OR seggeom > 000000002);

UPDATE dcp_zoning_taxlot_edm a
SET commercialoverlay2 = overlay
FROM commoverlayperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND (pergeom >= 10 OR seggeom > 000000002);

DROP TABLE commoverlayperorder;