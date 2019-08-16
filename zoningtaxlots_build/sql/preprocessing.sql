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

DROP TABLE IF EXISTS dcp_zoning_taxlot;

ALTER TABLE dcp_zoningtaxlots
RENAME TO dcp_zoning_taxlot;