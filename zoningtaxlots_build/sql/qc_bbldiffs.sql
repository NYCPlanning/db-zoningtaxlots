-- output a diff file with bbls that have changed in any field
DROP TABLE IF EXISTS bbldiffs;
CREATE TABLE bbldiffs AS(
SELECT a.*, 
	b.bbl as bblprev,
	b.zoningdistrict1 as zd1prev,
	b.zoningdistrict2 as zd2prev,
	b.zoningdistrict3 as zd3prev,
	b.zoningdistrict4 as zd4prev,
	b.commercialoverlay1 as co1prev,
	b.commercialoverlay2 as co2prev,
	b.specialdistrict1 as sd1prev,
	b.specialdistrict2 as sd2prev,
	b.specialdistrict3 as sd3prev,
	b.limitedheightdistrict as lhdprev,
	b.zoningmapnumber as zmnprev,
	b.zoningmapcode as zmcprev,
	c.geom
FROM dcp_zoning_taxlot a,
	dcp_zoning_taxlot_prev b,
	dof_dtm c
WHERE a.bbl::text = b.bbl::text AND a.bbl::text=c.bbl::text
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
	OR a.zoningmapcode<>b.zoningmapcode
	OR a.zoningdistrict1 IS NULL AND b.zoningdistrict1 IS NOT NULL
	OR a.zoningdistrict2 IS NULL AND b.zoningdistrict2 IS NOT NULL
	OR a.zoningdistrict3 IS NULL AND b.zoningdistrict3 IS NOT NULL
	OR a.zoningdistrict4 IS NULL AND b.zoningdistrict4 IS NOT NULL
	OR a.commercialoverlay1 IS NULL AND b.commercialoverlay1 IS NOT NULL
	OR a.commercialoverlay2 IS NULL AND b.commercialoverlay2 IS NOT NULL
	OR a.specialdistrict1 IS NULL AND b.specialdistrict1 IS NOT NULL
	OR a.specialdistrict2 IS NULL AND b.specialdistrict2 IS NOT NULL
	OR a.specialdistrict3 IS NULL AND b.specialdistrict3 IS NOT NULL
	OR b.zoningmapnumber IS NULL AND a.zoningmapnumber IS NOT NULL
	OR b.zoningmapcode IS NULL AND a.zoningmapcode IS NOT NULL
	OR b.zoningdistrict1 IS NULL AND a.zoningdistrict1 IS NOT NULL
	OR b.zoningdistrict2 IS NULL AND a.zoningdistrict2 IS NOT NULL
	OR b.zoningdistrict3 IS NULL AND a.zoningdistrict3 IS NOT NULL
	OR b.zoningdistrict4 IS NULL AND a.zoningdistrict4 IS NOT NULL
	OR b.commercialoverlay1 IS NULL AND a.commercialoverlay1 IS NOT NULL
	OR b.commercialoverlay2 IS NULL AND a.commercialoverlay2 IS NOT NULL
	OR b.specialdistrict1 IS NULL AND a.specialdistrict1 IS NOT NULL
	OR b.specialdistrict2 IS NULL AND a.specialdistrict2 IS NOT NULL
	OR b.specialdistrict3 IS NULL AND a.specialdistrict3 IS NOT NULL
	OR b.zoningmapnumber IS NULL AND a.zoningmapnumber IS NOT NULL
	OR b.zoningmapcode IS NULL AND a.zoningmapcode IS NOT NULL)
);