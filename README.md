# Cyclistic-Case-Study
Case Study: How Does a Bike-Share Navigate Speedy Success?  
Created by: Serina Lee  
Date: 8/9/2022

# Introduction
Hello world! This case study is part of the Google Data Analytics Certificate Program offered by Coursera.

## Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## About
Cyclistic is a bike-share offering company established in 2016. Since then, the program has grown to a fleet of 5,824 bicycles thatare geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.  

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers
who purchase annual memberships are Cyclistic members.

## Ask
1. How do annual members and casual riders use Cyclistic bikes differently?  
2. Why would casual riders buy Cyclistic annual memberships?  
3. How can Cyclistic use digital media to influence casual riders to become members?
  
  
# Prepare
## Description of all data sources used
Cyclistic's historical trip data was downloaded at [this link](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been made publicly available by Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement).

The data selected for analysis spans the past 12 months spanning from August 2021 to July 2022. The data was downloaded directly from the website as a compressed zip file, and then extracted into individual .csv files for each month. The "ride_id" column is the unique identifier column. In addition, the "rideable_type" column denotes the type of bike (classic, docked, electric) and the "member_casual" column states whether the rider is an annual member or a casual rider. The data also includes general ride logistics such as where and when the ride started and ended.
