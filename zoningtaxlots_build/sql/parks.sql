-- processing PARK designations
-- set the zoning district 1 value to PARK
-- where a zoning district is BALL FIELD, PLAYGROUND, or PUBLIC PLACE
UPDATE dcp_zoning_taxlot a
SET zoningdistrict1 = 'PARK'
WHERE zoningdistrict1 = 'BALL FIELD'
	OR zoningdistrict1 = 'PLAYGROUND'
	OR zoningdistrict1 = 'PUBLIC PLACE'
	OR zoningdistrict1 = 'PARK';
-- where zoningdistrict1 = 'PARK' NULL out all other zoning information
UPDATE dcp_zoning_taxlot a
SET zoningdistrict2 = NULL,
	zoningdistrict3 = NULL,
	zoningdistrict4 = NULL,
	commercialoverlay1 = NULL,
	commercialoverlay2 = NULL,
	specialdistrict1 = NULL,
	specialdistrict2 = NULL,
	specialdistrict3 = NULL,
	limitedheightdistrict = NULL
WHERE zoningdistrict1 = 'PARK';