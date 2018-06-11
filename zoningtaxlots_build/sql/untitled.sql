-- add FAR values based on zonedist and using lookup table
DROP TABLE IF EXISTS fars;
-- create view of lookup table
CREATE TABLE fars AS (
	SELECT zoningdistrict,
		resequivalent,
		NULL AS residfar,
		 (CASE
			WHEN commfar IS NULL THEN commfarr6otr10
			ELSE commfar
		END) AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_comm
	UNION
	SELECT zoningdistrict,
	 	NULL AS resequivalent,
		NULL AS residfar,
		mnffar AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_mnf
	UNION
	SELECT zoningdistrict,
		NULL AS resequivalent,
		resfarbasic AS residfar,
		NULL AS commfar,
		commfacfar AS facilfar
	FROM dcp_zoning_res1to5
	UNION
	SELECT zoningdistrict,
		NULL AS resequivalent,
		(CASE
			WHEN widestreetfarmax IS NOT NULL THEN widestreetfarmax
			ELSE farmax
			END) AS residfar,
		 NULL AS commfar,
		commfacfar AS facilfar
	FROM dcp_zoning_res6to10
);
UPDATE fars
SET zoningdistrict = LEFT(zoningdistrict,length(zoningdistrict)-2)
WHERE zoningdistrict LIKE '%HF';
UPDATE fars
SET zoningdistrict = LEFT(zoningdistrict,length(zoningdistrict)-3)
WHERE zoningdistrict LIKE '%QHO';
-- update resid and commfacility far based on resequivalent
UPDATE fars a
SET residfar = c.residfar
FROM (SELECT a.resequivalent, b.residfar, b.facilfar 
	FROM fars a
	JOIN fars b
	ON a.resequivalent=b.zoningdistrict
) c
WHERE c.resequivalent=a.resequivalent;
UPDATE fars a
SET facilfar = c.facilfar
FROM (SELECT a.resequivalent, b.residfar, b.facilfar 
	FROM fars a
	JOIN fars b
	ON a.resequivalent=b.zoningdistrict
) c
WHERE c.resequivalent=a.resequivalent;
--
DROP TABLE IF EXISTS dcp_zoningdistricts_fars;
CREATE TABLE dcp_zoningdistricts_fars AS (
SELECT a.zonedist, b.*, a.geom
FROM dcp_zoningdistricts a
LEFT JOIN fars b
ON a.zonedist=b.zoningdistrict);

-- zoning district with / first part 
UPDATE dcp_zoningdistricts_fars a
SET zoningdistricttype = b.zoningdistricttype,
	resequivalent = b.resequivalent,
	residfar = b.residfar,
	commfar = b.commfar,
	mnffar = b.mnffar,
	facilfar = b.facilfar,
	widestreetfarmax = b.widestreetfarmax
FROM fars b
WHERE split_part(a.zonedist, '/', 1)=b.zoningdistrict
AND a.zonedist LIKE '%/%';
-- zoning district with / second part
UPDATE dcp_zoningdistricts_fars a
SET zoningdistricttype = b.zoningdistricttype
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.zoningdistricttype IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET resequivalent = b.resequivalent
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.resequivalent IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET mnffar = b.mnffar
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.mnffar IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.facilfar IS NULL;
UPDATE dcp_zoningdistricts_fars a
SET widestreetfarmax = b.widestreetfarmax
FROM fars b
WHERE split_part(a.zonedist, '/', 2)=b.zoningdistrict
AND a.widestreetfarmax IS NULL;

UPDATE dcp_zoningdistricts_fars a
SET residfar = b.residfar
FROM fars b
WHERE a.resequivalent=b.zoningdistrict
AND a.residfar IS NULL;

SELECT COUNT(DISTINCT zonedist||zoningdistricttype||residfar||commfar||mnffar||facilfar||widestreetfarmax)
FROM dcp_zoningdistricts_fars;

pgsql2shp -u dbadmin -f zoningtaxlots_build/output/dcp_zoningdistricts_fars capdb "SELECT * FROM dcp_zoningdistricts_fars"

COPY (SELECT DISTINCT zonedist, zoningdistricttype, residfar, commfar, mnffar, facilfar, widestreetfarmax FROM dcp_zoningdistricts_fars) TO '/prod/db-zoningtaxlots/zoningtaxlots_build/output/dcp_zoningdistricts_fars.csv' DELIMITER ',' CSV HEADER;

