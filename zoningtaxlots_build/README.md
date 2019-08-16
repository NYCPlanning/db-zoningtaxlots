# Building the NYC Zoning Tax Lot Database

## Development workflow

### Fill in configuration file:

ztl.config.json

Your config file should look something like this:
{
"DBNAME":"databasename",
"DBUSER":"databaseuser"
}

These parameters are passed through the scripts allowing write access to the database.

### Build the NYC Zoning Tax Lot Database

Run the scripts in zoningtaxlots_build in order:
```
sh 01_dataloading.sh
sh 02_run_build.sh
sh 03_run_qaqc.sh
sh 04_archive.sh
```

#### 01_dataloading.sh
1. Make sure you have docker installed
2. do `sh 01_dataloading.sh` if you are in the zoningtaxlots_build directory
3. this shell command __1.__ spins up a `mdillon/postgis` containe __2.__ loads data into the container through `sptkl/docker-dataloading`

#### 02_build.sh
Creates the zoning tax lot database by:
1. Populating the empty data table with all the unique BBLs from DOF's DTM
2. Calculates how much of each tax lot if covered by a zoning feature and vice versa
3. Assigns zoning districts to each tax lot based on the given parameters.

Lastly, the final data table and associated lookup tables are outputted into the output folder.

#### 03_qaqc.sh
Executes a series of quality control reports, which are then outputted into the output folder.

#### 04_archive.sh
Export table to EDM_DATA