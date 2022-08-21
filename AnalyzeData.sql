-- Analyze Data

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

-- calculate average ride length for users by day of week
select member_casual, day_of_week, avg(ride_length)
from cyclistic_trip_data
group by member_casual, day_of_week -- save results into excel, avg_ride_length tab

-- recall ask #1: how do annual members and casual riders use cyclistic bikes differently?

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
group by member_casual, rideable_type -- most popular is classic bike for both members and casual riders
-- cyclistic annual members do not use docked bike
-- save into rideable_type tab

-- what is the most popular station to start a ride?
select start_station_name, count(ride_id) as num_rides_started_here
from cyclistic_trip_data
group by start_station_name
order by count(ride_id) desc
-- save into popular start station all tab

-- group by rider type
select start_station_name, member_casual, count(ride_id) as num_rides_started_here
from cyclistic_trip_data
group by start_station_name, member_casual
order by count(ride_id) desc -- save into popular start station tab

-- what is the most popular station to end a ride?
select end_station_name, count(ride_id) as num_rides_ended_here
from cyclistic_trip_data
group by end_station_name
order by count(ride_id) desc -- save into popular end station all tab

-- group by rider type
select end_station_name, member_casual, count(ride_id) as num_rides_ended_here
from cyclistic_trip_data
group by end_station_name, member_casual
order by count(ride_id) desc -- save into popular end station tab

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
