# Building the NYC Zoning Tax Lot Database

## Development workflow

### Fill in configuration file:

ztl.config.json

Your config file should look something like this:
{
"DBNAME":"databasename",
"DBUSER":"databaseuser"
}

These paramaters are passed through the scripts allowing write access to the database.

### Prepare data-loading-scripts

Clone and properly configure the data-loading-scripts repo: https://github.com/NYCPlanning/data-loading-scripts 
Make sure the database data-loading-scripts uses is the same one you listed in your ztl.config.json file.

### Build the NYC Zoning Tax Lot Database

Run the scripts in zoningtaxlots_build in order:

#### 01_dataloading.sh
Runs the data-loading-scripts scripts to import the datasets needed.

The raw datasets need to build the database are:
* Departmenet of Finance Digital Tax Map (DOF DTM)
* Department of City Planning NYC GIS Zoning Features

#### 02_build.sh
Creates the zoning tax lot database by:
1. Populating the empty data table with all the unique BBLs from DOF's DTM
2. Calculates how much of each tax lot if covered by a zoning feature and vice versa
3. Assigns zoning districts to each tax lot based on the given paramaters.

Lastly, the final data table and associated lookup tables are outputted into the output folder.

#### 03_qaqc.sh
Executes a series of quality control reports, which are then outputted into the output folder.