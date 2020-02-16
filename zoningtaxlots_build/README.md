# Build the NYC Zoning Tax Lot Database

Run the scripts in zoningtaxlots_build in order:
```
./01_dataloading.sh
./02_build.sh
./03_qaqc.sh
./04_archive.sh
```

#### ./01_dataloading.sh
1. Make sure you have docker installed
2. do `./01_dataloading.sh` if you are in the zoningtaxlots_build directory
3. this shell command loads data into the container through `sptkl/docker-dataloading`

#### ./02_build.sh
Creates the zoning tax lot database by:
1. Populating the empty data table with all the unique BBLs from DOF's DTM
2. Calculates how much of each tax lot if covered by a zoning feature and vice versa
3. Assigns zoning districts to each tax lot based on the given parameters.

Lastly, the final data table and associated lookup tables are outputted into the output folder.

#### ./03_qaqc.sh
Executes a series of quality control reports, which are then outputted into the output folder.

#### ./04_archive.sh
Export table to EDM_DATA

#### ./05_cleanup.sh
remove ztl database container and all the data generated