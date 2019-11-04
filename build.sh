#!/bin/sh
cd zoningtaxlots_build {
    echo "\e[1;34m Step 1: DATA LOADING ... \e[0m"
    echo .
    ./01_dataloading.sh
    echo "\e[1;35m Step 2: BUILDING ZONINGTAXLOTS... \e[0m"
    echo .
    ./02_build.sh
    echo "\e[1;31m Step 3: QAQC ... \e[0m"
    echo .
    ./03_qaqc.sh
    echo "\e[1;32m Step 4: ARCHIVE OUTPUT ... \e[0m"
    echo . 
    ./04_archive.sh
#     echo "\e[1;33m Step 5: CLEAN UP ... \e[0m"
#     echo .
#     ./05_cleanup.sh
cd -;}