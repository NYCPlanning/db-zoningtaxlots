DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningdistrict1;
CREATE TABLE ztl_qc_versioncomparison_zoningdistrict1 AS (
SELECT DISTINCT a.zoningdistrict1 as zoningdistrict1edm, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
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
GROUP BY a.zoningdistrict1, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
UNION 
SELECT DISTINCT a.zoningdistrict1, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict1 IS NULL AND b.zoningdistrict1 IS NOT NULL
GROUP BY a.zoningdistrict1, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningdistrict2;
CREATE TABLE ztl_qc_versioncomparison_zoningdistrict2 AS (
SELECT DISTINCT a.zoningdistrict2 as zoningdistrict2edm, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
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
GROUP BY a.zoningdistrict2, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
UNION 
SELECT DISTINCT a.zoningdistrict2, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict2 IS NULL AND b.zoningdistrict2 IS NOT NULL
GROUP BY a.zoningdistrict2, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningdistrict3;
CREATE TABLE ztl_qc_versioncomparison_zoningdistrict3 AS (
SELECT DISTINCT a.zoningdistrict3 as zoningdistrict3edm, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
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
GROUP BY a.zoningdistrict3, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
UNION 
SELECT DISTINCT a.zoningdistrict3, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict3 IS NULL AND b.zoningdistrict3 IS NOT NULL
GROUP BY a.zoningdistrict3, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningdistrict4;
CREATE TABLE ztl_qc_versioncomparison_zoningdistrict4 AS (
SELECT DISTINCT a.zoningdistrict4 as zoningdistrict4edm, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
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
GROUP BY a.zoningdistrict4, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
UNION 
SELECT DISTINCT a.zoningdistrict4, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningdistrict4 IS NULL AND b.zoningdistrict3 IS NOT NULL
GROUP BY a.zoningdistrict4, b.zoningdistrict1, b.zoningdistrict2, b.zoningdistrict3, b.zoningdistrict4
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_commercialoverlay1;
CREATE TABLE ztl_qc_versioncomparison_commercialoverlay1 AS (
SELECT DISTINCT a.commercialoverlay1 as commercialoverlay1edm, b.commercialoverlay1, b.commercialoverlay2, COUNT(*)
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
GROUP BY a.commercialoverlay1, b.commercialoverlay1, b.commercialoverlay2
UNION 
SELECT DISTINCT a.commercialoverlay1, b.commercialoverlay1, b.commercialoverlay2, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay1 IS NULL AND b.commercialoverlay1 IS NOT NULL
GROUP BY a.commercialoverlay1, b.commercialoverlay1, b.commercialoverlay2
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_commercialoverlay2;
CREATE TABLE ztl_qc_versioncomparison_commercialoverlay2 AS (
SELECT DISTINCT a.commercialoverlay2 as commercialoverlay2edm, b.commercialoverlay1, b.commercialoverlay2, COUNT(*)
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
GROUP BY a.commercialoverlay2, b.commercialoverlay1, b.commercialoverlay2
UNION 
SELECT DISTINCT a.commercialoverlay2, b.commercialoverlay1, b.commercialoverlay2, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.commercialoverlay2 IS NULL AND b.commercialoverlay2 IS NOT NULL
GROUP BY a.commercialoverlay2, b.commercialoverlay1, b.commercialoverlay2
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_specialdistrict1;
CREATE TABLE ztl_qc_versioncomparison_specialdistrict1 AS (
SELECT DISTINCT a.specialdistrict1 as specialdistrict1edm, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
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
GROUP BY a.specialdistrict1, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
UNION 
SELECT DISTINCT a.specialdistrict1, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict1 IS NULL AND b.specialdistrict1 IS NOT NULL
GROUP BY a.specialdistrict1, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_specialdistrict2;
CREATE TABLE ztl_qc_versioncomparison_specialdistrict2 AS (
SELECT DISTINCT a.specialdistrict2 as specialdistrict2edm, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
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
GROUP BY a.specialdistrict2, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
UNION 
SELECT DISTINCT a.specialdistrict2, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict2 IS NULL AND b.specialdistrict2 IS NOT NULL
GROUP BY a.specialdistrict2, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_specialdistrict3;
CREATE TABLE ztl_qc_versioncomparison_specialdistrict3 AS (
SELECT DISTINCT a.specialdistrict3 as specialdistrict3edm, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
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
GROUP BY a.specialdistrict3, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
UNION 
SELECT DISTINCT a.specialdistrict3, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.specialdistrict3 IS NULL AND b.specialdistrict3 IS NOT NULL
GROUP BY a.specialdistrict3, b.specialdistrict1, b.specialdistrict2, b.specialdistrict3
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_limitedheightdistrict;
CREATE TABLE ztl_qc_versioncomparison_limitedheightdistrict AS (
SELECT DISTINCT a.limitedheightdistrict as limitedheightdistrictedm, b.limitedheightdistrict, COUNT(*)
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
GROUP BY a.limitedheightdistrict, b.limitedheightdistrict
UNION
SELECT DISTINCT a.limitedheightdistrict, b.limitedheightdistrict, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.limitedheightdistrict IS NULL AND b.limitedheightdistrict IS NOT NULL
GROUP BY a.limitedheightdistrict, b.limitedheightdistrict
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningmapnumber;
CREATE TABLE ztl_qc_versioncomparison_zoningmapnumber AS (
SELECT DISTINCT a.zoningmapnumber as zoningmapnumberedm, b.zoningmapnumber, COUNT(*)
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
GROUP BY a.zoningmapnumber, b.zoningmapnumber
UNION
SELECT DISTINCT a.zoningmapnumber, b.zoningmapnumber, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapnumber IS NULL AND b.zoningmapnumber IS NOT NULL
GROUP BY a.zoningmapnumber, b.zoningmapnumber
);

DROP TABLE IF EXISTS ztl_qc_versioncomparison_zoningmapcode;
CREATE TABLE ztl_qc_versioncomparison_zoningmapcode AS (
SELECT DISTINCT a.zoningmapcode as zoningmapcodeedm, b.zoningmapcode, COUNT(*)
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
GROUP BY a.zoningmapcode, b.zoningmapcode
UNION
SELECT DISTINCT a.zoningmapcode, b.zoningmapcode, COUNT(*)
FROM dcp_zoning_taxlot_edm a
INNER JOIN dcp_zoning_taxlot b
ON a.bbl::text=b.boroughcode||lpad(b.taxblock, 5, '0')||lpad(b.taxlot, 4, '0')::text
WHERE a.zoningmapcode IS NULL AND b.zoningmapcode IS NOT NULL
GROUP BY a.zoningmapcode, b.zoningmapcode
);

\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict1) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningdistrict1.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict2) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningdistrict2.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict3) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningdistrict3.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict4) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningdistrict4.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_commercialoverlay1) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_commercialoverlay1.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_commercialoverlay2) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_commercialoverlay2.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict1) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_specialdistrict1.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict2) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_specialdistrict2.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict3) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_specialdistrict3.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_limitedheightdistrict) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_limitedheightdistrict.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_zoningmapnumber) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningmapnumber.csv';
\copy (SELECT * FROM ztl_qc_versioncomparison_zoningmapcode) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison_zoningmapcode.csv';



