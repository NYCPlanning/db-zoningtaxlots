-- calculate how much (total area and percentage) of each lot is covered by a zoning map
-- assign the zoning map to each tax lot
-- the order zoning maps are assigned is based on which map covers the majority of the lot
-- a map is only assigned if more than 10% of the map covers the lot
-- OR more than a specified area of the lot if covered by the map

DROP TABLE zoningmapperorder;
CREATE TABLE zoningmapperorder AS (
WITH 
zoningmapper AS (
SELECT p.bbl, n.sectionalm,
  (ST_Area(CASE 
    WHEN ST_CoveredBy(p.geom, n.geom) 
    THEN p.geom 
    ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) 
    END)) as segbblgeom,
  ST_Area(p.geom) as allbblgeom,
  (ST_Area(CASE 
    WHEN ST_CoveredBy(n.geom, p.geom) 
    THEN n.geom 
    ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      ) 
    END)) as segzonegeom,
  ST_Area(n.geom) as allzonegeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_limitedheight AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, sectionalm, segbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY seggeom DESC) AS row_number
  		FROM zoningmapper
);

UPDATE dcp_zoning_taxlot a
SET zoningmapnumber = sectionalm
FROM zoningmapperorder b
WHERE a.bbl=b.bbl
AND row_number = 1
AND (perbblgeom >= 10
  OR perzonegeom >= 50);

-- set the zoningmapcode to Y where a lot is covered by a second zoning map
UPDATE dcp_zoning_taxlot a
SET zoningmapcode = 'Y'
FROM zoningmapperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2;

DROP TABLE zoningmapperorder;