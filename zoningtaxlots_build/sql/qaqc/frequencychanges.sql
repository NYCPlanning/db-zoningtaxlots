CREATE TEMP TABLE qaqc_frequency_change (
    WITH newfrequency AS (
        SELECT 'zoningdistrict1' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningdistrict1 IS NOT NULL
        UNION
        SELECT 'zoningdistrict2' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningdistrict2 IS NOT NULL
        UNION
        SELECT 'zoningdistrict3' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningdistrict3 IS NOT NULL
        UNION
        SELECT 'zoningdistrict4' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningdistrict4 IS NOT NULL
        UNION
        SELECT 'commercialoverlay1' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE commercialoverlay1 IS NOT NULL
        UNION
        SELECT 'commercialoverlay2' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE commercialoverlay2 IS NOT NULL
        UNION
        SELECT 'specialdistrict1' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE specialdistrict1 IS NOT NULL
        UNION
        SELECT 'specialdistrict2' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE specialdistrict2 IS NOT NULL
        UNION
        SELECT 'specialdistrict3' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE specialdistrict3 IS NOT NULL
        UNION
        SELECT 'limitedheightdistrict' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE limitedheightdistrict IS NOT NULL
        UNION
        SELECT 'zoningmapnumber' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningmapnumber IS NOT NULL
        UNION
        SELECT 'zoningmapcode' as field, COUNT(*) as countnew
        FROM dcp_zoningtaxlots.:"VERSION" 
        WHERE zoningmapcode IS NOT NULL),
    oldfrequency AS (
        SELECT 'zoningdistrict1' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningdistrict1 IS NOT NULL
        UNION
        SELECT 'zoningdistrict2' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningdistrict2 IS NOT NULL
        UNION
        SELECT 'zoningdistrict3' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningdistrict3 IS NOT NULL
        UNION
        SELECT 'zoningdistrict4' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningdistrict4 IS NOT NULL
        UNION
        SELECT 'commercialoverlay1' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE commercialoverlay1 IS NOT NULL
        UNION
        SELECT 'commercialoverlay2' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE commercialoverlay2 IS NOT NULL
        UNION
        SELECT 'specialdistrict1' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE specialdistrict1 IS NOT NULL
        UNION
        SELECT 'specialdistrict2' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE specialdistrict2 IS NOT NULL
        UNION
        SELECT 'specialdistrict3' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE specialdistrict3 IS NOT NULL
        UNION
        SELECT 'limitedheightdistrict' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE limitedheightdistrict IS NOT NULL
        UNION
        SELECT 'zoningmapnumber' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningmapnumber IS NOT NULL
        UNION
        SELECT 'zoningmapcode' as field, COUNT(*) as countold
        FROM dcp_zoningtaxlots.:"VERSION_PREV"
        WHERE zoningmapcode IS NOT NULL)
    SELECT a.field, 
            a.countnew, 
            b.countold, 
            :'VERSION' as version,
            :'VERSION_PREV' as version_prev
    FROM newfrequency a
    JOIN oldfrequency b
    ON a.field = b.field
    ORDER BY countnew::numeric - countold::numeric DESC        
);

\COPY qaqc_frequency_change TO PSTDOUT DELIMITER ',' CSV HEADER;