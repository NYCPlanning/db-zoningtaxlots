DROP TABLE IF EXISTS ztl_qc_versioncomparisoncount;
-- input the versions of pluto that you'd like to compare
CREATE TABLE ztl_qc_versioncomparisoncount AS (
WITH differences AS (
SELECT 'zoningdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict1 = b.zoningdistrict1
	OR a.zoningdistrict1 = b.zoningdistrict2
	OR a.zoningdistrict1 = b.zoningdistrict3
	OR a.zoningdistrict1 = b.zoningdistrict4
	)
AND a.zoningdistrict1 IS NOT NULL
UNION 
SELECT 'zoningdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict1 IS NULL AND b.zoningdistrict1 IS NOT NULL
UNION
SELECT 'zoningdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict2 = b.zoningdistrict1
	OR a.zoningdistrict2 = b.zoningdistrict2
	OR a.zoningdistrict2 = b.zoningdistrict3
	OR a.zoningdistrict2 = b.zoningdistrict4
	)
AND a.zoningdistrict2 IS NOT NULL
UNION 
SELECT 'zoningdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict2 IS NULL AND b.zoningdistrict2 IS NOT NULL
UNION
SELECT 'zoningdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict3 = b.zoningdistrict1
	OR a.zoningdistrict3 = b.zoningdistrict2
	OR a.zoningdistrict3 = b.zoningdistrict3
	OR a.zoningdistrict3 = b.zoningdistrict4
	)
AND a.zoningdistrict3 IS NOT NULL
UNION 
SELECT 'zoningdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict3 IS NULL AND b.zoningdistrict3 IS NOT NULL
UNION
SELECT 'zoningdistrict4' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict4 = b.zoningdistrict1
	OR a.zoningdistrict4 = b.zoningdistrict2
	OR a.zoningdistrict4 = b.zoningdistrict3
	OR a.zoningdistrict4 = b.zoningdistrict4
	)
AND a.zoningdistrict4 IS NOT NULL
UNION 
SELECT 'zoningdistrict4' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict4 IS NULL AND b.zoningdistrict4 IS NOT NULL
UNION
SELECT 'commercialoverlay1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay1 = b.commercialoverlay1
	OR a.commercialoverlay1 = b.commercialoverlay2
	)
AND a.commercialoverlay1 IS NOT NULL
UNION 
SELECT 'commercialoverlay1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay1 IS NULL AND b.commercialoverlay1 IS NOT NULL
UNION
SELECT 'commercialoverlay2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay2 = b.commercialoverlay1
	OR a.commercialoverlay2 = b.commercialoverlay2
	)
AND a.commercialoverlay2 IS NOT NULL
UNION
SELECT 'commercialoverlay2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay2 IS NULL AND b.commercialoverlay2 IS NOT NULL
UNION
SELECT 'specialdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE upper(a.specialdistrict1) = upper(b.specialdistrict1)
	OR upper(a.specialdistrict1) = upper(b.specialdistrict2)
	OR upper(a.specialdistrict1) = upper(b.specialdistrict3)
	)
AND a.specialdistrict1 IS NOT NULL
UNION 
SELECT 'specialdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict1 IS NULL AND b.specialdistrict1 IS NOT NULL
UNION
SELECT 'specialdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE upper(a.specialdistrict2) = upper(b.specialdistrict1)
	OR upper(a.specialdistrict2) = upper(b.specialdistrict2)
	OR upper(a.specialdistrict2) = upper(b.specialdistrict3)
	)
AND a.specialdistrict2 IS NOT NULL
UNION 
SELECT 'specialdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict2 IS NULL AND b.specialdistrict2 IS NOT NULL
UNION
SELECT 'specialdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE upper(a.specialdistrict3) = upper(b.specialdistrict1)
	OR upper(a.specialdistrict3) = upper(b.specialdistrict2)
	OR upper(a.specialdistrict3) = upper(b.specialdistrict3)
	)
AND a.specialdistrict3 IS NOT NULL
UNION 
SELECT 'specialdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict3 IS NULL AND b.specialdistrict3 IS NOT NULL
UNION
SELECT 'limitedheightdistrict' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.limitedheightdistrict = b.limitedheightdistrict
	)
AND a.limitedheightdistrict IS NOT NULL
UNION
SELECT 'limitedheightdistrict' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.limitedheightdistrict IS NULL AND b.limitedheightdistrict IS NOT NULL
UNION
SELECT 'zoningmapnumber' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapnumber = b.zoningmapnumber
	)
AND a.zoningmapnumber IS NOT NULL
UNION
SELECT 'zoningmapnumber' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapnumber IS NULL AND b.zoningmapnumber IS NOT NULL
UNION
SELECT 'zoningmapcode' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.bbl NOT IN (
SELECT a.bbl
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapcode = b.zoningmapcode
	)
AND a.zoningmapcode IS NOT NULL
UNION
SELECT 'zoningmapcode' AS field, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapcode IS NULL AND b.zoningmapcode IS NOT NULL
),
countall AS (
	SELECT COUNT(*) as countall
	FROM dcp_zoning_taxlot_edm a
	INNER JOIN dcp_zoning_taxlot b
	ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
)
SELECT a.field, SUM(a.count) as count, round(((SUM(a.count)/SUM(b.countall))*100),2) as percent
FROM differences a, countall b
GROUP BY field
ORDER BY percent DESC
);

\copy (SELECT * FROM ztl_qc_versioncomparisoncount) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/qc_versioncomparison.csv';