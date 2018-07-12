-- generate table reporting the amount of area based on the latest PLUTO 
-- loss or gained by each zoning district, overlays, etc.
WITH edmarea AS (
SELECT b.zd, SUM(lotarea::double precision) as areaedm 
FROM dcp_mappluto a
LEFT JOIN (
SELECT DISTINCT a.bbl, a.zoningdistrict1 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.zoningdistrict2 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.zoningdistrict3 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.zoningdistrict4 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.commercialoverlay1 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.commercialoverlay2 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.specialdistrict1 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.specialdistrict2 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.specialdistrict3 AS zd
FROM dcp_zoning_taxlot_edm a
UNION 
SELECT DISTINCT a.bbl, a.limitedheightdistrict AS zd
FROM dcp_zoning_taxlot_edm a
) b
ON a.bbl::text=b.bbl||'.00'::text
GROUP BY b.zd
),
dcparea AS (
SELECT b.zd, SUM(lotarea::double precision) as areadcp 
FROM dcp_mappluto a
LEFT JOIN (
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.zoningdistrict1 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.zoningdistrict2 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.zoningdistrict3 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.zoningdistrict4 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.commercialoverlay1 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.commercialoverlay2 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.specialdistrict1 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.specialdistrict2 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.specialdistrict3 AS zd
FROM dcp_zoning_taxlot a
UNION 
SELECT DISTINCT a.boroughcode||lpad(a.taxblock, 5, '0')||lpad(a.taxlot, 4, '0')::text AS bbl, a.limitedheightdistrict AS zd
FROM dcp_zoning_taxlot a
) b
ON a.bbl::text=b.bbl||'.00'::text
GROUP BY b.zd)

SELECT a.*, b.areadcp, a.areaedm-b.areadcp AS difference
FROM edmarea a
LEFT JOIN dcparea b
ON a.zd=b.zd
ORDER BY difference;
