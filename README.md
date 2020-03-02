# NYC Zoning Tax Lot Database ![CI](https://github.com/NYCPlanning/db-zoningtaxlots/workflows/CI/badge.svg)

The Zoning Tax Lot Database includes the zoning designations and zoning map associated with a specific tax lot.  Using the tax lots in the Department of Finance Digital Tax Map, zoning features from the Department of City Planning NYC GIS Zoning Features, and spatial analysis tools DCP assigns
a zoning district (includes commercial overlays, special districts, and limited height districts) to a tax lot if 10% or more of the tax lot is covered by the zoning feature and/or 50% or more of the zoning feature is within a tax lot.

Up to four zoning districts are reported for each tax lot intersected by zoning boundary lines, and the order in which zoning districts are assigned is based on how much of the tax lot is covered by each zoning district

For example: If tax lot 98 is divided by zoning boundary lines into four sections - Part A, Part B, Part C and Part D. Part A represents the largest portion of the lot, Part B is the second largest portion of the lot, Part C represents the third largest portion of the lot and Part D covers the smallest portion of the tax then ZONING DISTRICT 4 will contain the zoning associated with Part D.

The final data table is provided in a comma–separated values (CSV) file format where each record reports information on a tax lot and BBL is the unique ID.

Instructions on how to build the Zoning Tax Lot Database are included in the zoningtaxlots_build folder.

## Instructions: 
1. create zoningtaxlots_build/.env according to example.env
2. run `./build.sh` at root directory to build zoningtaxlots database

## Output Files: 
+ [qc_bbldiff.zip](https://edm-publishing.nyc3.cdn.digitaloceanspaces.com/db-zoningtaxlots/latest/output/qc_bbldiffs/qc_bbldiffs.zip)
+ [source_data_versions.csv](https://edm-publishing.nyc3.cdn.digitaloceanspaces.com/db-zoningtaxlots/latest/output/source_data_versions.csv)
+ [zoningtaxlots_db.csv](https://edm-publishing.nyc3.cdn.digitaloceanspaces.com/db-zoningtaxlots/latest/output/zoningtaxlot_db.csv)

## Last build: 
2020/03/02 Baiyue built ztl
