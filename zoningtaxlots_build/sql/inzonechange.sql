-- flagging records that are within an area that has recently been rezoned
UPDATE dcp_zoning_taxlot a
SET inzonechange = 'Y'
FROM dof_dtm b, dcp_zoningmapamendments c 
WHERE a.bbl=b.bbl 
AND ST_Intersects(b.geom,c.geom)
AND c.effective::date  >  CURRENT_DATE - INTERVAL '2 months';