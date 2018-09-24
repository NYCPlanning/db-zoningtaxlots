-- create a new previous table based on the latest version of the database
-- before overwriting the tablexs
DROP TABLE IF EXISTS dcp_zoning_taxlot_prev;
CREATE TABLE dcp_zoning_taxlot_prev AS (
SELECT * FROM dcp_zoning_taxlot);