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
WHERE a.zoningdistrict1 <> b.zoningdistrict1
UNION
SELECT 'zoningdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict2 <> b.zoningdistrict2
UNION
SELECT 'zoningdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict3 <> b.zoningdistrict3
UNION
SELECT 'zoningdistrict4' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningdistrict4 <> b.zoningdistrict4
UNION
SELECT 'commercialoverlay1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.commercialoverlay1 <> b.commercialoverlay1
UNION
SELECT 'commercialoverlay2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.commercialoverlay2 <> b.commercialoverlay2
UNION
SELECT 'specialdistrict1' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict1 <> b.specialdistrict1
UNION
SELECT 'specialdistrict2' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict2 <> b.specialdistrict2
UNION
SELECT 'specialdistrict3' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.specialdistrict3 <> b.specialdistrict3
UNION
SELECT 'limitedheightdistrict' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.limitedheightdistrict <> b.limitedheightdistrict
UNION
SELECT 'zoningmapnumber' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningmapnumber <> b.zoningmapnumber
UNION
SELECT 'zoningmapcode' AS field, COUNT(*)
FROM dcp_zoning_taxlot_new a
INNER JOIN dcp_zoning_taxlot_old b
ON a.bbl::text=b.bbl::text
WHERE a.zoningmapcode <> b.zoningmapcode
)
SELECT * FROM countchange ORDER BY count DESC
);

-- write to an output file
-- set the denominator
COPY(
SELECT a.field, a.count, round(((a.count::double precision/49911)*100)::numeric,2) AS percentmismatch
FROM pluto_qc_versioncomparisoncount a
ORDER BY count DESC
) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparison.csv' DELIMITER ',' CSV HEADER;


