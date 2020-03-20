delete from dcp_zoningtaxlots.qaqc_mismatch
where version = :'VERSION';

insert into dcp_zoningtaxlots.qaqc_mismatch (
    SELECT
    count(*) as total,
    count(nullif(a.boroughcode = b.boroughcode, true)) as boroughcode,
    count(nullif(a.taxblock = b.taxblock, true)) as taxblock,
    count(nullif(a.taxlot = b.taxlot, true)) as taxlot,
    count(nullif(a.bbl = b.bbl, true)) as bbl,
    count(nullif(a.zoningdistrict1 = b.zoningdistrict1, true)) as zoningdistrict1,
    count(nullif(a.zoningdistrict2 = b.zoningdistrict2, true)) as zoningdistrict2,
    count(nullif(a.zoningdistrict3 = b.zoningdistrict3, true)) as zoningdistrict3,
    count(nullif(a.zoningdistrict4 = b.zoningdistrict4, true)) as zoningdistrict4,
    count(nullif(a.commercialoverlay1 = b.commercialoverlay1, true)) as commercialoverlay1,
    count(nullif(a.commercialoverlay2 = b.commercialoverlay2, true)) as commercialoverlay2,
    count(nullif(a.specialdistrict1 = b.specialdistrict1, true)) as specialdistrict1,
    count(nullif(a.specialdistrict2 = b.specialdistrict2, true)) as specialdistrict2,
    count(nullif(a.specialdistrict3 = b.specialdistrict3, true)) as specialdistrict3,
    count(nullif(a.limitedheightdistrict = b.limitedheightdistrict, true)) as limitedheightdistrict,
    count(nullif(a.zoningmapnumber = b.zoningmapnumber, true)) as zoningmapnumber,
    count(nullif(a.zoningmapcode = b.zoningmapcode, true)) as zoningmapcode,
    :'VERSION' as version,
    :'VERSION_PREV' as version_prev
    FROM dcp_zoningtaxlots.:"VERSION" a
    INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
    ON b.bbl=a.bbl
);