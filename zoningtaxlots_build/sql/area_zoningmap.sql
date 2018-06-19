DROP TABLE zoningmapperorder;
CREATE TABLE zoningmapperorder AS (
WITH 
zoningmapper AS (
SELECT p.bbl, n.sectionalm
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      ) END)) as seggeom,
    ST_Area(p.geom) as allgeom
 FROM dof_dtm AS p 
   INNER JOIN dcp_zoningmapindex AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, sectionalm, seggeom, (seggeom/allgeom)*100 as pergeom, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY seggeom DESC) AS row_number
  		FROM zoningmapper
);

UPDATE dcp_zoning_taxlot_edm a
SET zoningmapnumber = sectionalm
FROM zoningmapperorder b
WHERE a.bbl=b.bbl
AND row_number = 1
AND (pergeom >= 10 OR seggeom > 000000002);

UPDATE dcp_zoning_taxlot_edm a
SET zoningmapcode = 'Y'
FROM zoningmapperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2;

DROP TABLE zoningmapperorder;