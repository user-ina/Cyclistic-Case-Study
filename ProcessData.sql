-- copy data into new table for backup
SELECT * INTO cyclistic_trip_data_backup
FROM cyclistic_trip_data

-- check for duplicates by counting unique ride_id's
SELECT COUNT(DISTINCT ride_id)
FROM cyclistic_trip_data 
-- 5,901,463 distinct rows, which is same as total number of rows in dataset. Thus, all ride id's are unique

-- check for invalid data in the member_casual column
SELECT DISTINCT member_casual
FROM cyclistic_trip_data -- only values are member and casual, so all values are valid in this column

-- check for dates outside the scope
SELECT *
FROM cyclistic_trip_data
WHERE started_at <= '2021-08-01 00:00:00' or started_at >= '2022-07-31 23:59:59' -- all started_at data within the period

SELECT *
FROM cyclistic_trip_data
WHERE ended_at <= '2021-08-01 00:00:00' or started_at >= '2022-07-31 23:59:59' -- all ended_at data within the period, let's proceed

-- check for null values 
SELECT COUNT(*)
FROM cyclistic_trip_data
WHERE 
ride_id is not null or 
rideable_type is not null or
started_at is not null or
ended_at is not null
-- row count did not change, so these columns are all filled

-- checking if every station name has a matching station id
SELECT start_station_name, start_station_id
FROM cyclistic_trip_data
WHERE start_station_name is null OR (start_station_id is null OR start_station_id IS NOT NULL)
GROUP BY start_station_name, start_station_id
ORDER BY start_station_name -- there are several station IDs for a particular start station name. let's just use the station names and drop the station IDs for consistency

-- delete start and end station IDs
ALTER TABLE cyclistic_trip_data
DROP COLUMN start_station_id

ALTER TABLE cyclistic_trip_data
DROP COLUMN end_station_id

-- now delete any null values for station names
DELETE
FROM cyclistic_trip_data
WHERE start_station_name is null or end_station_name is null

-- look at table again to check if data looks right
SELECT *
FROM cyclistic_trip_data -- looks good!

-- create a new column for ride length
ALTER TABLE cyclistic_trip_data
ADD COLUMN ride_length INTERVAL

UPDATE cyclistic_trip_data
SET ride_length = (ended_at - started_at)

-- check if any ride lengths are <= 0
SELECT *
FROM cyclistic_trip_data
WHERE ride_length <= '00:00:00'

-- 273 rows with with invalid ride lengths, let's remove these rows to ensure our data isn't compromised
SELECT COUNT(*) FROM cyclistic_trip_data

-- let's create another backup with this new updated table before deleting data
SELECT * INTO cyclistic_trip_data_backup2
FROM cyclistic_trip_data

DELETE FROM cyclistic_trip_data
WHERE ride_length <= '00:00:00'

-- create new column for day of the week
ALTER TABLE cyclistic_trip_data
ADD COLUMN day_of_week DOUBLE PRECISION

-- use EXTRACT function to get day of the week from when the bike ride started
-- use isodow to return day of week as Monday (1) to Sunday (7)
SELECT started_at, EXTRACT(isodow from started_at) as dayofweek
FROM cyclistic_trip_data

UPDATE cyclistic_trip_data
SET day_of_week = EXTRACT(isodow from started_at)

-- make sure day_of_week only has values from 1 to 7 (Mon - Sun)
SELECT *
FROM cyclistic_trip_data
WHERE day_of_week < 1 or day_of_week > 7 -- 0 rows affected, great!

-- extract the months too so we can easily analyze the data by months
SELECT started_at, EXTRACT(MONTH FROM started_at) as month
FROM cyclistic_trip_data

ALTER TABLE cyclistic_trip_data
ADD COLUMN month double precision

UPDATE cyclistic_trip_data
SET month = EXTRACT(MONTH FROM started_at)

-- make sure no months outside of values 1 to 12 (jan - dec)
SELECT *
FROM cyclistic_trip_data
WHERE month < 1 or month > 12 -- 0 rows!


SELECT * FROM cyclistic_trip_data
