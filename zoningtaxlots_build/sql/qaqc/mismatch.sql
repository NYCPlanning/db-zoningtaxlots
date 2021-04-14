delete from dcp_zoningtaxlots.qaqc_mismatch
where version = :'VERSION';

insert into dcp_zoningtaxlots.qaqc_mismatch (
    SELECT
    count(*) as total,
    count(nullif(coalesce(a.boroughcode, 'NULL') = coalesce(b.boroughcode, 'NULL'), true)) as boroughcode,
    count(nullif(coalesce(a.taxblock, 'NULL') = coalesce(b.taxblock, 'NULL'), true)) as taxblock,
    count(nullif(coalesce(a.taxlot, 'NULL') = coalesce(b.taxlot, 'NULL'), true)) as taxlot,
    count(nullif(coalesce(a.bbl, 'NULL') = coalesce(b.bbl, 'NULL'), true)) as bbl,
    count(nullif(coalesce(a.zoningdistrict1, 'NULL') = coalesce(b.zoningdistrict1, 'NULL'), true)) as zoningdistrict1,
    count(nullif(coalesce(a.zoningdistrict2, 'NULL') = coalesce(b.zoningdistrict2, 'NULL'), true)) as zoningdistrict2,
    count(nullif(coalesce(a.zoningdistrict3, 'NULL') = coalesce(b.zoningdistrict3, 'NULL'), true)) as zoningdistrict3,
    count(nullif(coalesce(a.zoningdistrict4, 'NULL') = coalesce(b.zoningdistrict4, 'NULL'), true)) as zoningdistrict4,
    count(nullif(coalesce(a.commercialoverlay1, 'NULL') = coalesce(b.commercialoverlay1, 'NULL'), true)) as commercialoverlay1,
    count(nullif(coalesce(a.commercialoverlay2, 'NULL') = coalesce(b.commercialoverlay2, 'NULL'), true)) as commercialoverlay2,
    count(nullif(coalesce(a.specialdistrict1, 'NULL') = coalesce(b.specialdistrict1, 'NULL'), true)) as specialdistrict1,
    count(nullif(coalesce(a.specialdistrict2, 'NULL') = coalesce(b.specialdistrict2, 'NULL'), true)) as specialdistrict2,
    count(nullif(coalesce(a.specialdistrict3, 'NULL') = coalesce(b.specialdistrict3, 'NULL'), true)) as specialdistrict3,
    count(nullif(coalesce(a.limitedheightdistrict, 'NULL') = coalesce(b.limitedheightdistrict, 'NULL'), true)) as limitedheightdistrict,
    count(nullif(coalesce(a.zoningmapnumber, 'NULL') = coalesce(b.zoningmapnumber, 'NULL'), true)) as zoningmapnumber,
    count(nullif(coalesce(a.zoningmapcode, 'NULL') = coalesce(b.zoningmapcode, 'NULL'), true)) as zoningmapcode,
    :'VERSION' as version,
    :'VERSION_PREV' as version_prev
    FROM dcp_zoningtaxlots.:"VERSION" a
    INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
    ON b.bbl=a.bbl
);