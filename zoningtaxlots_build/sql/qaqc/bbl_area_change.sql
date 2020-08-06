DELETE FROM dcp_zoningtaxlots.qaqc_bblareachange
WHERE version = :'VERSION'; 

INSERT INTO dcp_zoningtaxlots.qaqc_bblareachange (
SELECT 
    bbl,
    newarea,
    oldarea,
    areadiff,
    :'VERSION' as version,
    :'VERSION_PREV' as version_prev
FROM (
    SELECT DISTINCT a.bbl, a.area as newarea, b.area as oldarea, (a.area - b.area) as areadiff
    FROM dcp_zoningtaxlots.:"VERSION" a
    INNER JOIN dcp_zoningtaxlots.:"VERSION_PREV" b
    ON a.bbl=b.bbl) c
);