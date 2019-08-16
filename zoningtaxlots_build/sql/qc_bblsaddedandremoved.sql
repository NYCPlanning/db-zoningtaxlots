-- report the the number of BBLS removed from and added to the latest zoning taxlot database
DROP TABLE IF EXISTS bblcountchange;
CREATE TABLE bblcountchange AS (
WITH joinall AS (
SELECT a.bbl as bblnew, b.bbl as bblold
FROM dcp_zoning_taxlot a
FULL OUTER JOIN
dcp_zoning_taxlot_prev b
ON b.bbl = a.bbl
),
reported AS (
SELECT 'removed' AS bbls, COUNT(*) FROM joinall WHERE bblnew IS NULL
UNION
SELECT 'added' AS bbls, COUNT(*) FROM joinall WHERE bblold IS NULL
)
SELECT * FROM reported);

-- \copy (SELECT * FROM bblcountchange) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/qc_bbls_count_added_removed.csv' DELIMITER ',' CSV HEADER;
-- DROP TABLE IF EXISTS bblcountchange;