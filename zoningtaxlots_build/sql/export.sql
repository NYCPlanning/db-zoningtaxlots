-- export zoning tax lot database with desired headings
DROP TABLE IF EXISTS dcp_zoning_taxlot_export;
CREATE TABLE dcp_zoning_taxlot_export AS(
	SELECT boroughcode AS "Borough Code",
		trunc(taxblock::numeric) AS "Tax Block",
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

-- export unique value lookup tables
\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/zoningtaxlot_zonedistricts.csv' DELIMITER ',' CSV HEADER;
\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/zoningtaxlot_commoverlay.csv' DELIMITER ',' CSV HEADER;
\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/zoningtaxlot_specialdistricts.csv' DELIMITER ',' CSV HEADER;
\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/zoningtaxlot_limitedheight.csv' DELIMITER ',' CSV HEADER;