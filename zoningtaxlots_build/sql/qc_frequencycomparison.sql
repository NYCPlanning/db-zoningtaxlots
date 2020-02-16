-- reports how many records are populated in each field
-- for the current and previous version of the zoning tax lot database
DROP TABLE IF EXISTS frequencychanges;
CREATE TABLE frequencychanges AS(
WITH newfrequency AS (
	SELECT 'zoningdistrict1' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningdistrict1 IS NOT NULL
	UNION
	SELECT 'zoningdistrict2' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningdistrict2 IS NOT NULL
	UNION
	SELECT 'zoningdistrict3' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningdistrict3 IS NOT NULL
	UNION
	SELECT 'zoningdistrict4' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningdistrict4 IS NOT NULL
	UNION
	SELECT 'commercialoverlay1' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE commercialoverlay1 IS NOT NULL
	UNION
	SELECT 'commercialoverlay2' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE commercialoverlay2 IS NOT NULL
	UNION
	SELECT 'specialdistrict1' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE specialdistrict1 IS NOT NULL
	UNION
	SELECT 'specialdistrict2' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE specialdistrict2 IS NOT NULL
	UNION
	SELECT 'specialdistrict3' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE specialdistrict3 IS NOT NULL
	UNION
	SELECT 'limitedheightdistrict' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE limitedheightdistrict IS NOT NULL
	UNION
	SELECT 'zoningmapnumber' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningmapnumber IS NOT NULL
	UNION
	SELECT 'zoningmapcode' as field, COUNT(*) as countnew
	FROM dcp_zoning_taxlot
	WHERE zoningmapcode IS NOT NULL),
oldfrequency AS (
	SELECT 'zoningdistrict1' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningdistrict1 IS NOT NULL
	UNION
	SELECT 'zoningdistrict2' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningdistrict2 IS NOT NULL
	UNION
	SELECT 'zoningdistrict3' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningdistrict3 IS NOT NULL
	UNION
	SELECT 'zoningdistrict4' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningdistrict4 IS NOT NULL
	UNION
	SELECT 'commercialoverlay1' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE commercialoverlay1 IS NOT NULL
	UNION
	SELECT 'commercialoverlay2' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE commercialoverlay2 IS NOT NULL
	UNION
	SELECT 'specialdistrict1' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE specialdistrict1 IS NOT NULL
	UNION
	SELECT 'specialdistrict2' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE specialdistrict2 IS NOT NULL
	UNION
	SELECT 'specialdistrict3' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE specialdistrict3 IS NOT NULL
	UNION
	SELECT 'limitedheightdistrict' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE limitedheightdistrict IS NOT NULL
	UNION
	SELECT 'zoningmapnumber' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningmapnumber IS NOT NULL
	UNION
	SELECT 'zoningmapcode' as field, COUNT(*) as countold
	FROM dcp_zoning_taxlot_prev
	WHERE zoningmapcode IS NOT NULL)
SELECT a.field, a.countnew, b.countold
FROM newfrequency a
JOIN oldfrequency b
ON a.field = b.field
ORDER BY countnew::numeric - countold::numeric DESC
);

-- \copy (SELECT * FROM frequencychanges) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/qc_frequencychanges.csv' DELIMITER ',' CSV HEADER;
-- DROP TABLE IF EXISTS frequencychanges;
-- DROP TABLE IF EXISTS bbldiffs;