# ZONING TAX LOTS DATABASE - METADATA README

## OVERVIEW

The Zoning Tax Lot Database contains all tax lots from the specified version of the Department
of Finance’s Digital Tax Map. For each tax lot, it specifies the applicable zoning district(s),
commercial overlay(s), special purpose district(s), and other zoning related information.
DCP assigns a zoning feature (includes zoning districts, special districts, and limited height
districts) to a tax lot if 10% or more of the tax lot is covered by the zoning feature. For
commercial overlays, a tax lot is assigned a value if 10% or more of the tax lot is covered by the
commercial overlay and/or 50% or more of the commercial overlay feature is within the tax lot.
The zoning features are taken from the Department of City Planning NYC GIS Zoning Features

## SOURCE DATASETS

* Department of Finance Digital Tax Map<br>October 26, 2018
* Department of City Planning NYC GIS Zoning Features<br>October 26, 2018

## CHANGE HISTORY

* With this release of the Zoning Tax Lot Database, DCP has changed the methodology
used to create the database. This change brings the database into alignment with DCP
NYC GIS Zoning Features. 
* Previous versions of the Zoning Tax Lot Database used a variety of sources to identify
parkland. Starting with this version, tax lots that intersect with areas designated in NYC
GIS Zoning Features as PARK, BALL FIELD, PLAYGROUND, and PUBLIC SPACES
have been assigned a single value of PARK in the Zoning Tax Lot Database. No other
parkland datasets are incorporated. The NYC GIS Zoning Features do not constitute a
definitive list of parks in the city. Lots designated as PARK should not be used to
calculate the amount of open space in an area.
* The abbreviations used to designate special districts have been changed to agree with
those in DCP NYC GIS Zoning Features.

## DISCLAIMER

The Zoning Tax Lot Database is being provided by the Department of City Planning (DCP) on
DCP’s website for informational purposes only. DCP does not warranty the completeness,
accuracy, content, or fitness for any particular purpose or use of the Zoning Tax Lot Database,
nor are any such warranties to be implied or inferred with respect to the Zoning Tax Lot
Database as furnished on the website.
DCP and the City are not liable for any deficiencies in the completeness, accuracy, content, or
fitness for any particular purpose or use of the Zoning Tax Lot Database or applications utilizing
the Zoning Tax Lot Database, provided by any third party.
