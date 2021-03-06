CREATE TEMP TABLE qaqc_new_nulls AS (
    WITH newnull AS (
		SELECT 'zoningdistrict1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict1 IS NULL AND b.zoningdistrict1 IS NOT NULL
		UNION
		SELECT 'zoningdistrict2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict2 IS NULL AND b.zoningdistrict2 IS NOT NULL
		UNION
		SELECT 'zoningdistrict3' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict3 IS NULL AND b.zoningdistrict3 IS NOT NULL
		UNION
		SELECT 'zoningdistrict4' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict4 IS NULL AND b.zoningdistrict4 IS NOT NULL
		UNION
			SELECT 'commercialoverlay1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.commercialoverlay1 IS NULL AND b.commercialoverlay1 IS NOT NULL
		UNION
		SELECT 'commercialoverlay2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.commercialoverlay2 IS NULL AND b.commercialoverlay2 IS NOT NULL
		UNION
		SELECT 'specialdistrict1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict1 IS NULL AND b.specialdistrict1 IS NOT NULL
		UNION
		SELECT 'specialdistrict2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict2 IS NULL AND b.specialdistrict2 IS NOT NULL
		UNION
		SELECT 'specialdistrict3' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict3 IS NULL AND b.specialdistrict3 IS NOT NULL
		UNION
		SELECT 'limitedheightdistrict' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.limitedheightdistrict IS NULL AND b.limitedheightdistrict IS NOT NULL
		UNION
		SELECT 'zoningmapnumber' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningmapnumber IS NULL AND b.zoningmapnumber IS NOT NULL
		UNION
		SELECT 'zoningmapcode' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningmapcode IS NULL AND b.zoningmapcode IS NOT NULL
	),
	newvalue AS (
		SELECT 'zoningdistrict1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict1 IS NOT NULL AND b.zoningdistrict1 IS NULL
		UNION
		SELECT 'zoningdistrict2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict2 IS NOT NULL AND b.zoningdistrict2 IS NULL
		UNION
		SELECT 'zoningdistrict3' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict3 IS NOT NULL AND b.zoningdistrict3 IS NULL
		UNION
		SELECT 'zoningdistrict4' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningdistrict4 IS NOT NULL AND b.zoningdistrict4 IS NULL
		UNION
		SELECT 'commercialoverlay1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.commercialoverlay1 IS NOT NULL AND b.commercialoverlay1 IS NULL
		UNION
			SELECT 'commercialoverlay2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.commercialoverlay2 IS NOT NULL AND b.commercialoverlay2 IS NULL
		UNION
		SELECT 'specialdistrict1' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict1 IS NOT NULL AND b.specialdistrict1 IS NULL
		UNION
		SELECT 'specialdistrict2' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict2 IS NOT NULL AND b.specialdistrict2 IS NULL
		UNION
		SELECT 'specialdistrict3' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.specialdistrict3 IS NOT NULL AND b.specialdistrict3 IS NULL
		UNION
		SELECT 'limitedheightdistrict' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.limitedheightdistrict IS NOT NULL AND b.limitedheightdistrict IS NULL
		UNION
		SELECT 'zoningmapnumber' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningmapnumber IS NOT NULL AND b.zoningmapnumber IS NULL
		UNION
			SELECT 'zoningmapcode' AS field, COUNT(*)
			FROM dcp_zoningtaxlots.:"VERSION" a
			INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
			ON a.bbl=b.bbl
			WHERE a.zoningmapcode IS NOT NULL AND b.zoningmapcode IS NULL
	)
	SELECT a.field, 
			a.count as value_to_null, 
			b.count as null_to_value,
			:'VERSION' as version,
			:'VERSION_PREV' as version_prev
	FROM newnull a
	LEFT JOIN newvalue b
	ON a.field=b.field
	ORDER BY value_to_null, null_to_value DESC
);

\COPY qaqc_new_nulls TO PSTDOUT DELIMITER ',' CSV HEADER;