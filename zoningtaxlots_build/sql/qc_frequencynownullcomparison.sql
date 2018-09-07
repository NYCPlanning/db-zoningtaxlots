DROP TABLE IF EXISTS ztl_qc_versioncomparisonnownullcount;
-- input the versions of zoning districts that you'd like to compare
CREATE TABLE ztl_qc_versioncomparisonnownullcount AS (
SELECT 'zoningdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningdistrict1 IS NULL AND b.zoningdistrict1 IS NOT NULL
UNION
SELECT 'zoningdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningdistrict2 IS NULL AND b.zoningdistrict2 IS NOT NULL
UNION
SELECT 'zoningdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningdistrict3 IS NULL AND b.zoningdistrict3 IS NOT NULL
UNION
SELECT 'zoningdistrict4' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningdistrict4 IS NULL AND b.zoningdistrict4 IS NOT NULL
UNION
SELECT 'commercialoverlay1' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.commercialoverlay1 IS NULL AND b.commercialoverlay1 IS NOT NULL
UNION
SELECT 'commercialoverlay2' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.commercialoverlay2 IS NULL AND b.commercialoverlay2 IS NOT NULL
UNION
SELECT 'specialdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.specialdistrict1 IS NULL AND b.specialdistrict1 IS NOT NULL
UNION
SELECT 'specialdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.specialdistrict2 IS NULL AND b.specialdistrict2 IS NOT NULL
UNION
SELECT 'specialdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.specialdistrict3 IS NULL AND b.specialdistrict3 IS NOT NULL
UNION
SELECT 'limitedheightdistrict' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.limitedheightdistrict IS NULL AND b.limitedheightdistrict IS NOT NULL
UNION
SELECT 'zoningmapnumber' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningmapnumber IS NULL AND b.zoningmapnumber IS NOT NULL
UNION
SELECT 'zoningmapcode' AS field, COUNT(*)
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl
WHERE a.zoningmapcode IS NULL AND b.zoningmapcode IS NOT NULL
);

\copy (SELECT * FROM ztl_qc_versioncomparisonnownullcount ORDER BY count DESC) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/DTM_180405/qc_versioncomparisonnownullcount.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS ztl_qc_versioncomparisonnownullcount;