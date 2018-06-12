SELECT COUNT(*)
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