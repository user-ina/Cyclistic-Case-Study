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

# Analyze
Now that our data is processed and cleaned, we are ready to begin analyzing for patterns and trends. We start trying to understanding the data a little more by performing some simple queries:

```sql
-- calculate the mean of ride_length
select avg(ride_length) as avg_ride_length
from cyclistic_trip_data -- result: 00:18:30.35902

-- calculate the longest ride length
select max(ride_length) as max_ride_length
from cyclistic_trip_data -- 28 days 21:49:10

-- validate the data and find out more information about this 28 day bike ride
select ride_id, rideable_type, started_at, ended_at, ride_length
from cyclistic_trip_data
group by ride_id
order by ride_length desc

-- see what day of the week is most popular for rides
select day_of_week, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by day_of_week -- saturday the most popular, followed by sunday.
```

We are ready to start addressing the business task - converting casual riders to annual members. In order to do this, we will aggregate data and perform calculations to identify trends and relationships. We will save analysis results into an Excel workbook by copying and pasting the results from each query into a new tab. If you are following along, please refer to the "AnalyzeData.xlsx" file, which is included in the repo. 

```sql
-- recall ask #1: how do annual members and casual riders use cyclistic bikes differently?

-- calculate average ride length for users by day of week
select member_casual, day_of_week, avg(ride_length)
from cyclistic_trip_data
group by member_casual, day_of_week -- save results into excel, avg_ride_length tab  

-- calculate the average ride length grouped by members and casual riders
select member_casual, avg(ride_length) as avg_ride_length
from cyclistic_trip_data
group by member_casual -- casual 00:26:37 ; member 00:12:36
-- save results into avg_ride_length2 tab

-- what days are popular for casual vs annual members?
select day_of_week, member_casual, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by day_of_week, member_casual -- casual riders significantly use cyclistic on saturday, then sunday; members most popular day is wednesday/tuesday/thursday
-- ASSUMPTION: members use cyclistic for commute during the work/school week and casual riders use cyclistic for fun on the weekend
-- save into day_of_week tab

-- which type of bike is most popular for casual vs annual members?
select member_casual, rideable_type, count(ride_id)
from cyclistic_trip_data
group by member_casual, rideable_type -- most popular is classic bike for both members and casual rdiers
-- cyclistic annual members do not use docked bike
-- save into rideable_type tab

-- what is the most popular station to start a ride? 
select start_station_name, count(ride_id) as no_of_rides_started_here
from cyclistic_trip_data
order by count(ride_id) desc -- save into popular start station all tab

-- group by rider type
select start_station_name, member_casual, count(ride_id) as no_of_rides_started_here
from cyclistic_trip_data
group by start_station_name, member_casual
order by count(ride_id) desc
-- save into popular start station tab

-- what is the most popular station to end a ride?
select end_station_name, count(ride_id) as no_of_rides_ended_here
from cyclistic_trip_data
group by end_station_name
order by count(ride_id) desc -- saved into popular end station all tab

-- group by rider type
select end_station_name, member_casual, count(ride_id) as no_of_rides_ended_here
from cyclistic_trip_data
group by end_station_name, member_casual
order by count(ride_id) desc
-- save into popular end station tab

-- since we have 12 months of data, let's make use of it
-- what is the most popular month for bike rides? analyze by all riders then by member type
select month, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by month
order by count(ride_id) desc -- summer months are most popular with august and july in the lead. winter months are least popular with january in last place.
-- ASSUMPTION: people enjoy bike rides in summer with warm weather compared to the winter months with cold weather

select month, member_casual, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by month, member_casual
order by count(ride_id) desc -- trends are similar for both casual and member riders. august is most popular and january is least popular
-- save into month tab

-- which month has the longest average bike rides? analyze by all then by member type
select month, avg(ride_length) as avg_ride_length
from cyclistic_trip_data
group by month
order by avg(ride_length) desc -- august longest and january shortest. spring/fall months are in the middle

select month, member_casual, avg(ride_length) as avg_ride_length
from cyclistic_trip_data
group by month, member_casual
order by avg(ride_length) desc -- august for casual riders, and june for members
-- this query shows us that on average, casual riders have an average ride length of 22 - 28 minutes throughout the year while members have an avg ride of 10-13 min
-- save into month & ride length tab

-- calculate count of member_casual
select member_casual, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by member_casual -- 1,949,253 rides from casual riders and 2,679,704 rides from annual members
-- save into member_casual tab

-- calculate count of rides per month grouped by member_casual
select member_casual, month, count(ride_id) as no_of_rides
from cyclistic_trip_data
group by member_casual, month -- save into rides per month tab
```

### Key insights
1. The casual rider has an overall longer average ride length compared to the annual member.
2. The most popular month for bike rides is in August for both casual riders and members. The least busy month is January for both rider types.
3. Casual riders take most rides during the weekends while annual members tend to ride more during the weekdays.


At this point, we have enough to work with in order to move on the next phase of the data analysis process, share. Let's move on, but know that we can always come back to write and run more queries if needed. 

# Share
Since we have saved results of our query into an Excel workbook, let's use Tableau to visualize our data. Tableau is a great data visualization tool that allows users to create all sorts of charts into worksheets and dashboards. A dashboard allows users to get a holistic view of all data on one screen.

We start by importing our excel workbook as the data source in Tableau. Upon validating the data types for each table, we notice that the average ride length is set as a string. Tableau does not have a "time" data type, but only a date & time format. As we are not able to properly work with time durations in Tableau, we revisited our Excel workbook. For each dataset that includes a time duration (tabs avg_ride_length, avg_ride_lenght2, month & ride length), we reformatted the value into a new column called "avg_ride_length_new". In order to reformat the values to a data type that would work in Tableau, we manually validated that all values were under 1 hour and eliminated the leading 0's and colon, which represented hours. We also replaced the decimal point to separate the minutes and seconds.

For instance, 00:28:33.873172 would turn into 28.338873172.

We kept the original column with the proper format to protect our data. However, in Tableau, we opted to hide the original column so as to not confuse ourselves during the share phase.
