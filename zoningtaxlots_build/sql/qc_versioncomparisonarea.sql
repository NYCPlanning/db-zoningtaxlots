SELECT SUM(lotarea::double precision)
FROM dcp_mappluto
WHERE bbl::text IN (
SELECT a.bbl::text||'.00' AS bbl
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
AND a.zoningdistrict1 IS NOT NULL AND (a.zoningdistrict1 <> 'PARK' AND a.zoningdistrict1 <> 'PLAYGROUND' OR a.zoningdistrict1 IS NULL) AND b.zoningdistrict1 = 'PARK'
);