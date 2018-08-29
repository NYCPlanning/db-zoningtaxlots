-- insert unique bbls into table
INSERT INTO dcp_zoning_taxlot (
	bbl,
	boroughcode,
	taxblock,
	taxlot
	)
SELECT DISTINCT bbl, boro, block, lot FROM dof_dtm;
-- populate bbl field if it's NULL
UPDATE dcp_zoning_taxlot
SET bbl = boroughcode||lpad(taxblock, 5, '0')||lpad(taxlot, 4, '0')::text
WHERE bbl IS NULL;