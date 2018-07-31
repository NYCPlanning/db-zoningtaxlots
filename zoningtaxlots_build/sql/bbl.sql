-- insert unique bbls into table
INSERT INTO dcp_zoning_taxlot (
	bbl,
	boroughcode,
	taxblock,
	taxlot
	)
SELECT DISTINCT bbl, boro, block, lot FROM dof_dtm;