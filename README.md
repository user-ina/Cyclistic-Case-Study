# Cyclistic-Case-Study
Case Study: How Does a Bike-Share Navigate Speedy Success?  
Created by: Serina Lee  
Date: 8/9/2022

## Introduction
Hello world! This case study is part of the Google Data Analytics Certificate Program offered by Coursera.

## Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## About
Cyclistic is a bike-share offering company established in 2016. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.  

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers
who purchase annual memberships are Cyclistic members.

# Ask
Help guide the future marketing program by addressing the following three questions:
1. How do annual members and casual riders use Cyclistic bikes differently?  
2. Why would casual riders buy Cyclistic annual memberships?  
3. How can Cyclistic use digital media to influence casual riders to become members?
  
  
# Prepare
## Description of all data sources used
Cyclistic's historical trip data was downloaded at [this link](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been made publicly available by Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement).

The data selected for analysis spans the past 12 months, ranging from August 2021 to July 2022. The data was downloaded directly from the website as a compressed zip file, and then extracted into individual .csv files for each month. The "ride_id" column is the unique identifier column. In addition, the "rideable_type" column denotes the type of bike (classic, docked, electric) and the "member_casual" column states whether the rider is an annual member or a casual rider. The data also includes general ride logistics such as where and when the ride started and ended.  



# Process
## Tools
To process the data from dirty to clean, I have chosen to use SQL (Postgres) due the large nature of the datasets. I knew SQL was the best choice compared to other applications such as spreadsheets considering Microsoft Excel was already crashing when I tried to preview the csv files!

## Data Integrity
In order to preserve the integrity of the data, I have made backup copies of each dataset and saved them into a folder. I also copy the data into a backup table periodically since the data cleansing process may involve removing large numbers of rows.

## Loading the data
I first started by creating a table for each of the 12 months of data, then importing the dataset files using the import/export function within pgAdmin 4 tool. I ensured the format was set to CSV, the header was set to "Yes," and the delimiter was set to a comma as the datasets are CSV files.

``` sql
CREATE TABLE aug2021(
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
```

Note that we can set the character types for each column in our create table script. This way, we don't have to go back and change it later ( unelss necessary).  

I then created a table "cyclistic_trip_data"and merged all 12 months of data into it. 

``` sql
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
```

This took around 3 minutes to execute, so I knew this was a large amount of data I was working with here.  
I ran a count query out of query-iosity (I had to) and determined that the "cyclistic_trip_data" has 5.9 million rows!
``` sql
SELECT COUNT(*)
FROM cyclistic_trip_data
```

## Cleaning the data

### Check for duplicates
I first started by validating if the primary key column (ride_id) was a true unique identifier by checking for any duplicate values.

```sql
-- check for duplicates by counting unique ride_id's
SELECT COUNT(DISTINCT ride_id)
FROM cyclistic_trip_data 
-- 5,901,463 distinct rows, which is matches the total number of rows in cyclistic_trip_data dataset. Thus, all ride_id's are unique.

```  

### Check for valid data
I then checked to ensure all data in the "member_casual" column was valid.
``` sql
-- check for invalid data in the member_casual column
SELECT DISTINCT member_casual
FROM cyclistic_trip_data -- only values are 'member 'and 'casual,' so all values are valid in this column
```  
Next, let's check to make sure all the data is inside our sampled range of August 2021 to July 2022 using the "started_at" and "ended_at" values.
``` sql
SELECT *
FROM cyclistic_trip_data
WHERE started_at <= '2021-08-01 00:00:00' or started_at >= '2022-07-31 23:59:59' -- all bike rides started within the sampled period

SELECT *
FROM cyclistic_trip_data
WHERE ended_at <= '2021-08-01 00:00:00' or started_at >= '2022-07-31 23:59:59' -- all bike rides ended within the sampled period as well, let's proceed
```

### Review null data
Now, let's address the large number of null values we saw when previewing the data. We'll start off by determining which key fields have null values.
```sql
-- check for null values 
SELECT COUNT(*)
FROM cyclistic_trip_data
WHERE 
ride_id is not null or 
rideable_type is not null or
started_at is not null or
ended_at is not null
-- row count did not change, so these columns are all filled
```

For the station information, we noted there was a column for both the station name and station ID. Let's check if every station name has a single matching station ID (1:1 relationship). If so, we can fill any null station names with the station ID, and vice versa in order to preserve as much of our data!

### Remove null data

``` sql
-- checking if every station name has a matching station id
SELECT start_station_name, start_station_id
FROM cyclistic_trip_data
WHERE start_station_name is null OR (start_station_id is null OR start_station_id IS NOT NULL)
GROUP BY start_station_name, start_station_id
ORDER BY start_station_name 
-- there are several station IDs for a particular start station name, it seems like the data is jumbled. 
-- upon reviewing the query results, we decide to drop the station ID columns and just use station names as the values are more consistent  

-- delete start and end station ID columns
ALTER TABLE cyclistic_trip_data
DROP COLUMN start_station_id

ALTER TABLE cyclistic_trip_data
DROP COLUMN end_station_id

-- now let's delete any null values for station names
DELETE
FROM cyclistic_trip_data
WHERE start_station_name is null or end_station_name is null

-- look at table again to check if data looks right
SELECT *
FROM cyclistic_trip_data -- looks good!
```

Great! We're almost done with cleaning our data. Before we finish, let's create some new columns to help us analyze the data later on.

### Create new columns
```sql
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


SELECT * FROM cyclistic_trip_data -- let's check out how our data is looking
```







