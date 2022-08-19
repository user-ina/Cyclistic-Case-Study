-- process data
-- first, i have to load all csv files into the database. let's create individual tables to store each month of data.

--  create august 2021 table
CREATE TABLE august2021(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- rename to aug2021
ALTER table august2021
RENAME TO aug2021

-- create september 2021 table
CREATE TABLE sept2021(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create october 2021 table
CREATE TABLE oct2021(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create november 2021 table
CREATE TABLE nov2021(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create december 2021 table
CREATE TABLE dec2021(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create january 2022 table
CREATE TABLE jan2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create february 2022 table
CREATE TABLE feb2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create march 2022 table
CREATE TABLE march2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create april 2022 table
CREATE TABLE april2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create may 2022 table
CREATE TABLE may2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create june 2022 table
CREATE TABLE june2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- create july 2022 table
CREATE TABLE july2022(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- now that all the tables are loaded, i will use the UNION syntax to combine all 12 months data into a new table cyclistic_trip_data
-- first, i have to create the new table that will hold all 12 months data
CREATE TABLE cyclistic_trip_data(
ride_id varchar(200),
rideable_type varchar(200),
started_at timestamp,
ended_at timestamp,
start_station_name varchar(200),
start_station_id varchar(200),
end_station_name varchar(200),
end_station_id varchar(200),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual varchar(200),
PRIMARY KEY (ride_id)
)

-- 
-- note the UNION syntax removes any duplicate records, if applicable
-- aug2021 to july2022
INSERT INTO cyclistic_trip_data
SELECT * FROM aug2021
UNION
SELECT * FROM sept2021
UNION
SELECT * FROM oct2021
UNION
SELECT * FROM nov2021
UNION
SELECT * FROM dec2021
UNION
SELECT * FROM jan2022
UNION
SELECT * FROM feb2022
UNION
SELECT * FROM march2022
UNION
SELECT * FROM april2022
UNION
SELECT * FROM may2022
UNION
SELECT * FROM june2022
UNION
SELECT * FROM july2022

-- the query took almost 3 minutes to run, let's run a query and see how big this dataset is
SELECT
COUNT(*)
FROM cyclistic_trip_data

-- wow! that's 5.9 million rows (5,901,463 to be exact)

	
