DROP TABLE IF EXISTS dcp_zoning_taxlot_export;
CREATE TABLE dcp_zoning_taxlot_export AS(
	SELECT boroughcode AS "Borough Code",
		taxblock AS "Tax Block",
		taxlot AS "Tax Lot",
		bbl AS "BBL",
		zoningdistrict1 AS "Zoning District 1",
		zoningdistrict2 AS "Zoning District 2",
		zoningdistrict3 AS "Zoning District 3",
		zoningdistrict4 AS "Zoning District 4",
		commercialoverlay1 AS "Commercial Overlay 1",
		commercialoverlay2 AS "Commercial Overlay 2",
		specialdistrict1 AS "Special District 1",
		specialdistrict2 AS "Special District 2",
		specialdistrict3 AS "Special District 3",
		limitedheightdistrict AS "Limited Height District",
		zoningmapnumber AS "Zoning Map Number",
		zoningmapcode AS "Zoning Map Code"
FROM dcp_zoning_taxlot);

\copy (SELECT * FROM dcp_zoning_taxlot_export) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/zoningtaxlot_db.csv' DELIMITER ',' CSV HEADER;

DROP TABLE dcp_zoning_taxlot_export;