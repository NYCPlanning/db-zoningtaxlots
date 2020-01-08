-- Preprocessing (change column names and table names) 
ALTER TABLE dcp_commercialoverlay 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_limitedheight 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_mih 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_specialpurposesubdistricts 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_specialpurpose
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_zoningdistricts 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_zoningmapamendments 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_specialpurposesubdistricts 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dof_dtm 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE dcp_zoningmapindex 
RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE doitt_zipcodeboundaries 
RENAME COLUMN wkb_geometry TO geom;

DROP TABLE IF EXISTS dcp_zoning_taxlot;

ALTER TABLE dcp_zoningtaxlots
RENAME TO dcp_zoning_taxlot;

DROP TABLE IF EXISTS dof_dtm_tmp;
CREATE TABLE dof_dtm_tmp as(
SELECT bbl, boro, block, lot, ST_Multi(ST_Union(f.geom)) as geom
FROM dof_dtm As f
GROUP BY bbl, boro, block, lot);

DROP TABLE IF EXISTS dof_dtm;
ALTER TABLE dof_dtm_tmp
RENAME to dof_dtm;

CREATE INDEX dof_dtm_wkb_geometry_geom_idx ON dof_dtm USING GIST (geom gist_geometry_ops_2d);