-- output a file with bbls that have changed in size between verisons
CREATE TABLE bblareachange AS (
SELECT DISTINCT a.bbl, a.area as newarea, b.area as oldarea, (a.area - b.area) as areadiff
FROM dcp_zoning_taxlot a
INNER JOIN dcp_zoning_taxlot_prev b
ON a.bbl=b.bbl);

-- \copy (SELECT * FROM bblareachange) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/qc_bblareachange.csv' DELIMITER ',' CSV HEADER;
-- DROP TABLE IF EXISTS bblareachange;