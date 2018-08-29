-- output a diff file with bbls that have changed in any field
DROP TABLE IF EXISTS bbldiffs;
CREATE TABLE bbldiffs AS(
SELECT a.*, 
	b.bbl as bblprev,
	b.zoningdistrict1 as zoningdistrict1prev,
	b.zoningdistrict2 as zoningdistrict2prev,
	b.zoningdistrict3 as zoningdistrict3prev,
	b.zoningdistrict4 as zoningdistrict4prev,
	b.commercialoverlay1 as commercialoverlay1prev,
	b.commercialoverlay2 as commercialoverlay2prev,
	b.specialdistrict1 as specialdistrict1prev,
	b.specialdistrict2 as specialdistrict2prev,
	b.specialdistrict3 as specialdistrict3prev,
	b.limitedheightdistrict as limitedheightdistrictprev,
	b.zoningmapnumber as zoningmapnumberprev,
	b.zoningmapcode as zoningmapcodeprev,
	c.geom
FROM dcp_zoning_taxlot a,
	dcp_zoning_taxlot_prev b,
	dof_dtm c
WHERE a.bbl = b.bbl AND a.bbl=c.bbl
	AND (a.zoningdistrict1<>b.zoningdistrict1
	OR a.zoningdistrict2<>b.zoningdistrict2
	OR a.zoningdistrict3<>b.zoningdistrict3
	OR a.zoningdistrict4<>b.zoningdistrict4
	OR a.commercialoverlay1<>b.commercialoverlay1
	OR a.commercialoverlay2<>b.commercialoverlay2
	OR a.specialdistrict1<>b.specialdistrict1
	OR a.specialdistrict2<>b.specialdistrict2
	OR a.specialdistrict3<>b.specialdistrict3
	OR a.limitedheightdistrict<>b.limitedheightdistrict
	OR a.zoningmapnumber<>b.zoningmapnumber
	OR a.zoningmapcode<>b.zoningmapcode)
);

\copy (SELECT * FROM bbldiffs) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/qc_bbldiffs.csv' DELIMITER ',' CSV HEADER;