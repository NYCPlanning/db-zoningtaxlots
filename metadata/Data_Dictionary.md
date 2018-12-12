## ZONING TAX LOTS DATABASE - DATA DICTIONARY

The Zoning Tax Lot Data Dictionary defines the fields in the Zoning Tax Lot Database in order
of the field's position in the data file.

The Data Dictionary contains the following:

### Data Source:
The Data Source identifies the city agency and computer file or system from which the field was
obtained or derived.

### Description:
The Description includes a brief explanation of the field; and where pertinent, a description of
the abbreviated values. These abbreviations may be listed in a separate appendix.

|**Field Name:**|**Borough Code**|
|---|---|
|**Maximum Length:**|1 character|
|**Data Source:**|Department of Finance Digital Tax Map|
|**Description:**|The borough in which the tax lot is located. This field contains a two character borough code.|

***

|Abbreviation|Description|
|---|---|
|1|Manhattan|
|2|Bronx|
|3|Brooklyn|
|4|Queens|
|5|Staten Island|

**NOTE:** Two portions of the city, Marble Hill and Rikers Island, are each legally located in one borough but are serviced by a different borough. The **Borough Codes** associated with these areas are the boroughs in which they are legally located.

Specifically, Marble Hill is serviced by the Bronx, but is legally located in Manhattan and has a Manhattan **Borough Code**. Rikers Island is serviced by Queens, but is legally located in the Bronx and has a Bronx **Borough Code**.
***
|**Field Name:**|**Tax Block**|
|---|---|
|**Maximum Length:**|5 characters|
|**Data Source:**|Department of Finance Digital Tax Map|
|**Description:**|The tax block in which the tax lot is located.<br>This field contains a one to five digit tax block number.<br>Each tax block is unique within a borough (see **Borough Code**).|
***
|**Field Name:**|**Tax Lot**|
|---|---|
|**Maximum Length:**|4 characters|
|**Data Source:**|Department of Finance Digital Tax Map|
|**Description:**|The number of the tax lot.<br>This field contains a one to four digit tax lot number.<br>Each tax lot if unique within a tax block (see **Tax Block**)|
***
|**Field Name:**|**BBL**|
|---|---|
|**Maximum Length:**|10 characters|
|**Data Source:**|Department of Finance Digital Tax Map|
|**Description:**|A concatenation of the borough code, tax block and tax lot. <br> This field consists of the borough code followed by the tax block followed by the tax lot. The borough code is one numeric digit. The tax block is one to five numeric digits, preceded with leading zeros when the block is less than five digits. The tax lost is one to four digits and is preceded with leading zeros when the lot is less than four digits. Examples: Manhattan Borough Code 1, Tax Block 16, Tax Lot 100 would be stored as 1000160100. Brooklyn Borough Code 3, Tax Block 15828, Tax Lot 7501 would be stored as 5158287501.|
***
|**Field Name:**|**Zoning District 1**|
|---|---|
|**Maximum Length:**|9 characters|
|**Data Source:**|Department of City Planning NYC Zoning Districts|
|**Description:**|The zoning district classification of the tax lot. If the tax lot is divided by a zoning boundary line, Zoning District 1 represents the zoning district classification occupying the greatest percentage of the tax lot’s area. Only zoning districts that cover at least 10% of a tax lot’s area are included. Tax lots that intersect with areas designated in NYC GIS Zoning Features as PARK, BALL FIELD, PLAYGROUND, and PUBLIC SPACES have been assigned a single value of PARK in the Zoning Tax Lot Database. These NYC GIS Zoning Features do not constitute a definitive list of parks in the city. Lots designated as PARK should not be used to calculate the amount of open space in an area. For example, if Tax Lot 98 is divided by a zoning boundary line into Part A and Part B. Part A has the larger portion of the lot and is located in commercial zoning district while Part B is in residential zoning district; Zoning District 1 will have the commercial zoning district value associated with Part A. See Appendix B for information on field values.|
***
|**Field Name:**|**Zoning District 2**|
|---|---|
|**Maximum Length:**|9 characters|
|**Data Source:**|Department of City Planning NYC Zoning Districts|
|**Description:**|If the tax lot is divided by zoning boundary lines, Zoning District 2 represents the zoning classification occupying the second greatest percentage of the tax lot's area. If the tax lot is not divided by a zoning boundary line, the field is blank. For example, if Tax Lot 98 is divided by a zoning boundary line into Part A and Part B. Part A has the larger portion of the lot and is located in commercial zoning district while Part B is in residential zoning district; Zoning District 2 will have the residential zoning district value associated with Part B. See Appendix B for information on field values.|
***
|**Field Name:**|**Zoning District 3**|
|---|---|
|**Maximum Length:**|9 characters|
|**Data Source:**|Department of City Planning NYC Zoning Districts|
|**Description:**|If the tax lot is divided by zoning boundary lines, Zoning District 3 represents the zoning classification occupying the third greatest percentage of the tax lot's area. If the tax lot is not divided by two zoning boundary lines, the field is blank. For example, if Tax Lot 98 is divided by zoning boundary lines into three sections - Part A, Part B and Part C. Part A represents the largest portion of the lot, Part B is the second largest portion of the lot and Part C covers the smallest portion of the tax. Zoning District 3 will contain the zoning associated with Part C. See Appendix B for information on field values|
***
|**Field Name:**|**Zoning District 4**|
|---|---|
|**Maximum Length:**|9 characters|
|**Data Source:**|Department of City Planning NYC Zoning Districts|
|**Description:**|If the tax lot is divided by zoning boundary lines, Zoning District 4 represents the zoning classification occupying the fourth greatest percentage of the tax lot's area If the tax lot is not divided by three zoning boundary lines, the field is blank. For example, if Tax Lot 98 is divided by zoning boundary lines into four sections - Part A, Part B, Part C and Part D. Part A represents the largest portion of the lot, Part B is the second largest portion of the lot, Part C represents the third largest portion of the lot and Part D covers the smallest portion of the tax. Zoning District 4 will contain the zoning associated with Part D. See Appendix B for information on field values.|
***
|**Field Name:**|**Commercial Overlay 1**|
|---|---|
|**Maximum Length:**|4 characters|
|**Data Source:**|Department of City Planning NYC Commercial Overlay Districts|
|**Description:**|The commercial overlay assigned to the tax lot. If more than one commercial overlay exists on the tax lot, Commercial Overlay 1 represents the commercial overlay occupying the greatest percentage of the lot area. The commercial overlay district must either cover at least 10% of a tax lot’s area or at least 50% of the commercial overlay district must be contained within the tax lot. See Appendix C for valid field values.|
***
|**Field Name:**|**Commercial Overlay 2**|
|---|---|
|**Maximum Length:**|4 characters|
|**Data Source:**|Department of City Planning NYC Commercial Overlay Districts|
|**Description:**|The commercial overlay assigned to the tax lot. If more than one commercial overlay exists on the tax lot, Commercial Overlay 1 represents the commercial overlay occupying the greatest percentage of the lot area. The commercial overlay district must either cover at least 10% of a tax lot’s area or at least 50% of the commercial overlay district must be contained within the tax lot. See Appendix C for valid field values.|
***
|**Field Name:**|**Special District 1**|
|---|---|
|**Maximum Length:**|6 characters|
|**Data Source:**|Department of City Planning NYC Special Purpose Districts (Zoning)|
|**Description:**|The special purpose district assigned to the tax lot. With the exception of four areas in the city with overlapping special purpose districts, if more than one special purpose district exists on the tax lot, Special District 1 represents the special purpose district occupying the greatest percentage of the lot area. See Appendix A for special purpose district abbreviations and descriptions. See Appendix D for the handling of areas with overlapping special purpose districts.|
***
|**Field Name:**|**Special District 2**|
|---|---|
|**Maximum Length:**|6 characters|
|**Data Source:**|Department of City Planning NYC Special Purpose Districts (Zoning)|
|**Description:**|The special purpose district assigned to the tax lot. With the exception of areas in the city with overlapping special purpose districts, if the tax lot has more than one special purpose district, Special District 2 represents the special purpose district occupying the second greatest percentage of the lot area. See Appendix A for special purpose district abbreviations and descriptions. See Appendix D for the handling of areas with overlapping special purpose districts.|
***
|**Field Name:**|**Special District 3**|
|---|---|
|**Maximum Length:**|6 characters|
|**Data Source:**|Department of City Planning NYC Special Purpose Districts (Zoning)|
|**Description:**|The special purpose district assigned to the tax lot. With the exception of areas in the city with overlapping special purpose districts, if the tax lot has more than two special purpose district, Special District 3 represents the special purpose district occupying the third greatest percentage of the lot area. See Appendix A for special purpose district abbreviations and descriptions. See Appendix D for the handling of areas with overlapping special purpose districts.|
***
|**Field Name:**|**Limited Height District**|
|---|---|
|**Maximum Length:**|5 characters|
|**Data Source:**|Department of City Planning NYC Limited Height Districts (Zoning)|
|**Description:**|The limited height district assigned to the tax lot. Limited height districts are coded using the three to five character district symbols that are listed in Appendix E.|
***
|**Field Name:**|**Zoning Map Number**|
|---|---|
|**Maximum Length:**|3 characters|
|**Data Source:**|Department of City Planning Quartersection Map Index|
|**Description:**|The Zoning Map Number associated with the tax lot.|
***
|**Field Name:**|**Zoning Map Code**|
|---|---|
|**Maximum Length:**|1 character|
|**Data Source:**|Department of City Planning Quartersection Map Index|
|**Description:**|A code ‘Y’ indicates that the tax lot may be on the border of two or more Zoning Maps. If the Lot is on the border of two or more Zoning Maps the map number identified in Zoning Map Number is one of the potential Zoning Maps associated with the Tax Lot.|
***

### APPENDIX A: SPECIAL PURPOSE DISTRICTS

|**Abbreviation**|**Description**|
|---|---|
|125th|Special 125th Street District|
|125th/TA|Special 125th Street Dist/Transit Land use Dist|
|BPC|Special Battery Park City District|
|BR|Special Bay Ridge District|
|C|Special Grand Councourse Preservation District|
|CD|Special City Island District|
|CI|Special Coney Island District|
|CL|Special Clinton District|
|CO|Special Coney Island Mixed Use District|
|CP|Special College Point District|
|CR|Special Coastal Risk District|
|DB|Special Downtown Brooklyn District|
|DFR|Special Downtown Far Rockaway District|
|DJ|Special Downtown Jamaica District|
|EC-1|Special Enhanced Commercial District 1|
|EC-2|Special Enhanced Commercial District 2|
|EC-3|Special Enhanced Commercial District 3|
|EC-4|Special Enhanced Commercial District 4|
|EC-5|Special Enhanced Commercial District 5|
|EC-6|Special Enhanced Commercial District 6|
|EHC|East Harlem Corridors|
|EHC/TA|East Harlem Corridors/Transit Land Use District|
|FH|Special Forest Hills District|
|GC|Special Garment Center District|
|GI|Special Governance Island District|
|HP|Special Hunts Point District|
|HRP|Special Hudson River Park District|
|HRW|Special Harlem River Waterfront District|
|HS|Special Hillsides Preservation District|
|HSQ|Special Hudson Square District|
|HY|Special Hudson Yards District|
|IN|Special Inwood District|
|J|Jerome Avenue District|
|L|Special Lincoln Square District|
|LC|Special Limited Commercial District|
|LI|Special Little Italy District|
|LIC|Special Long Island City Mixed Use District|
|LM|Special Lower Manhattan District|
|MiD|Special Midtown District|
|MMU|Special Manhattanville Mixed Use District|
|MP|Special Madison Avenue Preservation District|
|MX-1|Special Mixed Use District (MX-1)|
|MX-2|Special Mixed Use District (MX-2)|
|MX-3|Special Mixed Use District (MX-3)|
|MX-4|Special Mixed Use District (MX-4)|
|MX-5|Special Mixed Use District (MX-5)|
|MX-6|Special Mixed Use District (MX-6)|
|MX-7|Special Mixed Use District (MX-7)|
|MX-8|Special Mixed Use District (MX-8)|
|MX-9|Special Mixed Use District (MX-9)|
|MX-10|Special Mixed Use District (MX-10)|
|MX-11|Special Mixed Use District (MX-11)|
|MX-12|Special Mixed Use District (MX-12)|
|MX-13|Special Mixed Use District (MX-13)|
|MX-14|Special Mixed Use District (MX-14)|
|MX-15|Special Mixed Use District (MX-15)|
|MX-16|Special Mixed Use District (MX-16)|
|MX-17|Special Mixed Use District (MX-17)|
|NA-1|Special Natural Area District|
|NA-2|Special Natural Area District|
|NA-3|Special Natural Area District|
|NA-4|Special Natural Area District|
|OP|Special Ocean Parkway District|
|PC|Special Planned Community Preservation District|
|PI|Special Park Improvement District|
|SB|Special Sheepshead Bay District|
|SG|Special St. George District|
|SHP|Special Southern Hunters Point District|
|SRD|Special South Richmond Development District|
|SRI|Special Southern Rooseevelt Island District|
|SV-1|Special Scenic View District|
|SW|Special Stapleton Waterfront District|
|TA|Special Transit Land Use District|
|TMU|Special Tribeca Mixed Use District|
|U|Special United Nations Development District|
|US|Special Union Square District|
|WCh|Special West Chelsea District|
|WP|Special Willets Point District|

***

### APPENDIX B: ZONING DISTRICTS

|**Abbreviation**|**Description**|
|---|---|
|R1-1 - R10H|Residential Districts|
|C1-6 - C8-4|Commercial Districts|
|M1-1 - M3-2|Manufacturing Districts|
|M1-1/R5 - M1-6/R10|Mixed Manufacturing & Residential Districts|
|BPC|Battery Park City|
|PARK|Areas designated as PARK, BALL FIELD, PLAYGROUND, and PUBLIC SPACES in NYC GIS Zoning Features.|

***

### APPENDIX C: COMMERCIAL OVERLAYS

Valid Commercial Overlay values: C1-1, C1-2, C1-3, C1-4, C1-5, C2-1, C2-2, C2-3, C2-4, C2-5

### APPENDIX D: OVERLAPPING SPECIAL PURPOSE DISTRICTS

In the area of Manhattan covered by both the Special Midtown District and the Special
Clinton District, **Special District 1** is CL and **Special District 2** is MiD.
* In the area of Manhattan covered by both the Special Midtown District and the Special
Transit District, **Special District 1** is MiD and **Special District 2** is TA.
* In the area of Manhattan covered by both the Special 125th Street District and the
Special Transit District, **Special District 1** is 125th and **Special District 2** is TA.
* In the area of Brooklyn covered by both the Special Enhanced Commercial District 5 or 6
and Mixed Use District MX-16 (Ocean Hill/East New York), **Special District 1** is EC-5 or
EC-6 and **Special District 2** is MX-16.

### APPENDIX E: LIMITED HEIGHT DISTRICTS

|**Abbreviation**|**Description**|
|---|---|
|LH-1|Limited Height District No. 1|
|LH-1A|Limited Height District No. 1A (Upper East Side)|
|LH-2|Limited Height District No. 2*|
|LH-3|Limited Height District No. 3*|
*There are currently no districts with these designations
