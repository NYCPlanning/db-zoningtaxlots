DROP TABLE IF EXISTS ztl_qc_versioncomparisoncount;
-- input the versions of pluto that you'd like to compare
CREATE TABLE ztl_qc_versioncomparisoncount AS (
	WITH dcp_zoning_taxlot_new AS (SELECT * FROM dcp_zoning_taxlot_edm),
dcp_zoning_taxlot_old AS (SELECT a.*, a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0') as bbl 
	FROM dcp_zoning_taxlot a),
countchange AS (
SELECT 'zoningdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict1 = b.zoningdistrict1
	OR a.zoningdistrict1 = b.zoningdistrict2
	OR a.zoningdistrict1 = b.zoningdistrict3
	OR a.zoningdistrict1 = b.zoningdistrict4
UNION
SELECT 'zoningdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict2 = b.zoningdistrict1
	OR a.zoningdistrict2 = b.zoningdistrict2
	OR a.zoningdistrict2 = b.zoningdistrict3
	OR a.zoningdistrict2 = b.zoningdistrict4
UNION
SELECT 'zoningdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict3 = b.zoningdistrict1
	OR a.zoningdistrict3 = b.zoningdistrict2
	OR a.zoningdistrict3 = b.zoningdistrict3
	OR a.zoningdistrict3 = b.zoningdistrict4
UNION
SELECT 'zoningdistrict4' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict4 = b.zoningdistrict1
	OR a.zoningdistrict4 = b.zoningdistrict2
	OR a.zoningdistrict4 = b.zoningdistrict3
	OR a.zoningdistrict4 = b.zoningdistrict4
UNION
SELECT 'commercialoverlay1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.commercialoverlay1 = b.commercialoverlay1
	OR a.commercialoverlay1 = b.commercialoverlay2
UNION
SELECT 'commercialoverlay2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.commercialoverlay2 = b.commercialoverlay1
	OR a.commercialoverlay2 = b.commercialoverlay2
UNION
SELECT 'specialdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict1 = b.specialdistrict1 
	OR a.specialdistrict1 = b.specialdistrict2
	OR a.specialdistrict1 = b.specialdistrict3
UNION
SELECT 'specialdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict2 = b.specialdistrict1 
	OR a.specialdistrict2 = b.specialdistrict2
	OR a.specialdistrict2 = b.specialdistrict3
UNION
SELECT 'specialdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict3 = b.specialdistrict1 
	OR a.specialdistrict3 = b.specialdistrict2
	OR a.specialdistrict3 = b.specialdistrict3
UNION
SELECT 'limitedheightdistrict' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.limitedheightdistrict = b.limitedheightdistrict
UNION
SELECT 'zoningmapnumber' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningmapnumber = b.zoningmapnumber
UNION
SELECT 'zoningmapcode' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningmapcode = b.zoningmapcode
)
SELECT * FROM countchange ORDER BY count DESC
);


-- write to an output file
-- set the denominator
COPY(
SELECT a.field, a.count, round(((a.count::double precision/849519)*100)::numeric,2) AS percentmismatch
FROM ztl_qc_versioncomparisoncount a
ORDER BY count DESC
) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison.csv' DELIMITER ',' CSV HEADER;


SELECT a.bbl, a.specialdistrict1, b.specialdistrict1 AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict1 <> b.specialdistrict1
GROUP BY a.specialdistrict1, b.specialdistrict1, a.bbl

SELECT DISTINCT a.specialdistrict1, b.specialdistrict1 AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict1 <> b.specialdistrict1
GROUP BY a.specialdistrict1, b.specialdistrict1

SELECT a.bbl, a.commercialoverlay1, b.commercialoverlay1 AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay1 <> b.commercialoverlay1
GROUP BY a.commercialoverlay1, b.commercialoverlay1, a.bbl

SELECT DISTINCT a.zoningmapnumber, b.zoningmapnumber AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapnumber <> b.zoningmapnumber
GROUP BY a.zoningmapnumber, b.zoningmapnumber

WITH allcount AS (
SELECT a.commercialoverlay1, b.commercialoverlay1 AS field, b.commercialoverlay2, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay1 <> b.commercialoverlay1
	OR a.commercialoverlay1 <> b.commercialoverlay2
GROUP BY a.commercialoverlay1, b.commercialoverlay1, b.commercialoverlay2
)
SELECT SUM(count) FROM allcount

73931

SELECT COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text