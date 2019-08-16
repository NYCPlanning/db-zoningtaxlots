# outputting ztl db shapefile
pgsql2shp -u postgres -h localhost -f \
    /home/zoningtaxlots_build/output/zoningtaxlot_db postgres \
    'SELECT a.*, b.geom 
    FROM dcp_zoning_taxlot_export a, dof_dtm b 
    WHERE a."BBL"=b.bbl AND b.geom IS NOT NULL;'

start=$(date +'%T')
echo "QC the zoning tax lot database"
psql -U postgres -h localhost -f sql/qc_versioncomparisonfields.sql
psql -U postgres -h localhost -f sql/qc_bblsaddedandremoved.sql
psql -U postgres -h localhost -f sql/qc_bbldiffs.sql
# psql -U postgres -h localhost -f sql/qc_versioncomparisonarea.sql
# psql -U postgres -h localhost -f sql/qc_bblareachange.sql

pgsql2shp -u postgres -h localhost -f \
    /home/zoningtaxlots_build/output/qc_bbldiffs postgres \
    "SELECT * FROM bbldiffs WHERE geom IS NOT NULL"

psql -U postgres -h localhost -f sql/qc_frequencycomparison.sql
psql -U postgres -h localhost -f sql/qc_frequencynownullcomparison.sql

# psql -U postgres -h localhost -c "\copy (SELECT * FROM bblareachange) 
#                                     TO '/home/zoningtaxlots_build/output/qc_bblareachange.csv' 
#                                     DELIMITER ',' CSV HEADER;"

psql -U postgres -h localhost -c "\copy (SELECT * FROM bbldiffs) 
                                    TO '/home/zoningtaxlots_build/output/qc_bbldiffs.csv' 
                                    DELIMITER ',' CSV HEADER;"

psql -U postgres -h localhost -c "\copy (SELECT * FROM bblcountchange) 
                                    TO '/home/zoningtaxlots_build/output/qc_bbls_count_added_removed.csv' 
                                    DELIMITER ',' CSV HEADER;"

psql -U postgres -h localhost -c "\copy (SELECT * FROM frequencychanges) 
                                    TO '/home/zoningtaxlots_build/output/qc_frequencychanges.csv' 
                                    DELIMITER ',' CSV HEADER;"

psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparisonnownullcount) 
                                    TO '/home/zoningtaxlots_build/output/qc_versioncomparisonnownullcount.csv' 
                                    DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparisoncount) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict1 ORDER BY count DESC)
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningdistrict1.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict2 ORDER BY count DESC)
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningdistrict2.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict3 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningdistrict3.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningdistrict4 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningdistrict4.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_commercialoverlay1 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_commercialoverlay1.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_commercialoverlay2 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_commercialoverlay2.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict1 ORDER BY count DESC)
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_specialdistrict1.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict2 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_specialdistrict2.csv'
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_specialdistrict3 ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_specialdistrict3.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_limitedheightdistrict ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_limitedheightdistrict.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningmapnumber ORDER BY count DESC) 
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningmapnumber.csv' 
#                                     DELIMITER ',' CSV HEADER;"

# psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparison_zoningmapcode ORDER BY count DESC)
#                                     TO '/home/zoningtaxlots_build/output/qc_versioncomparison_zoningmapcode.csv' 
#                                     DELIMITER ',' CSV HEADER;"