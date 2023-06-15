--DATA CLEANING OF BELLABEATFIT
--Counting Distinct users on each table
		SELECT COUNT(DISTINCT(ID)) 33users
		FROM Daily_activity

		SELECT COUNT(DISTINCT(ID)) 24users
		FROM Sleep_day

		SELECT COUNT(DISTINCT(ID)) 33users
		FROM Daily_calories

		SELECT COUNT(DISTINCT(ID)) 24users
		FROM Minute_sleep

		SELECT COUNT(DISTINCT(ID)) 8users
		FROM WeightLogInfo

		SELECT COUNT(DISTINCT(ID)) 33users
		FROM Daily_Steps

--Checking of duplicaton values on each table

select id, activityDay, count (*) 
from Daily_Activity
GROUP BY ID, ActivityDay
HAVING COUNT (*) >1
No duplicate found
select id, activityDay, count (*) 
from Daily_Steps
GROUP BY ID, ActivityDay
HAVING COUNT (*) >1
No duplicate found

select id, activityDay, count (*) 
from Daily_calories
GROUP BY ID, ActivityDay
HAVING COUNT (*) >1
No duplicate found

select id, SleepDay, count (*) 
from Sleep_day
GROUP BY ID, SleepDay HAVING COUNT (*) >1
3 Duplicate found

select id, date, count (*) 
from Minute_sleep
GROUP BY ID, date
HAVING COUNT (*) >1
No duplicate found

select id, Date, count (*) 
from WeightLogInfo
GROUP BY ID, Date
HAVING COUNT (*) >1
--No duplicate found



select id, Date from hourlySteps_merged
GROUP BY ID, Date
HAVING COUNT (*) >1

--3 Duplicates removed

;with cte as (select Id, SleepDay,TotalSleepRecords,
row_number() over (partition by id, sleepday, totalsleeprecords 
order by id,sleepday, totalsleeprecords) rownum from Sleep_day)
Delete from cte where rownum > 1

--I ADDED DAYOFWEEK column to both daily_activity and sleepday table
ALTER TABLE Daily_Activity
ADD Day_of_Week char(10)

ALTER TABLE Sleep_day
ADD Day_of_Week char(10)


--Updating weekday to the DayofWeek column I just created. 

UPDATE Daily_activity
SET Day_of_week = daTEname(WEEKDAY,ActivityDate)
SELECT * FROM Daily_activity

UPDATE Sleep_day
SET Day_of_Week =daTEname(WEEKDAY,SleepDay)

--I create a new table adding dailyactivity and sleep day to do some analysis based on the new column I just added to both.

create table Daily_Activity_Sleep
(Id float, ActivityDate DATETIME2 (7), TotalSteps INT, TotalDistance FLOAT , VeryActiveDistance Float , ModeratelyDistance FLOAT,
LightActiveDistance Float, SedentaryActiveDistance FLOAT , VeryActiveMinutes FLOAT, FairlyActiveMinutes FLOAT , 
LightlyActiveMinutes FLOAT, SedentaryMinutes FLOAT, Calories FlOAT, Day_Of_Week CHAR(10),TotalMinutesAsleep FLOAT,
TotalTimeInBed FLOAT,TotalSleepRecords INT)

INSERT INTO Daily_Activity_Sleep
(ID, ActivityDate, TotalSteps, TotalDistance,VeryActiveDistance, ModeratelyDistance, LightActiveDistance, SedentaryActiveDistance, 
VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories, Day_Of_Week,TotalMinutesAsleep,TotalTimeInBed ,TotalSleepRecords)
select * from Daily_Activity_Sleep
		 SELECT 
     A.Id,
	 ActivityDate,
	 TotalSteps,
	CAST (TotalDistance AS FLOAT) AS TotalDistance, 
	CAST (VeryActiveDistance AS FLOAT) AS VeryActiveDistance,
	CAST (ModeratelyActiveDistance  AS FLOAT)  ModeratelyDistance ,
	CAST (LightActiveDistance AS FLOAT) LightActiveDistance,
	CAST (SedentaryActiveDistance AS FLOAT) SedentaryActiveDistance,
	 CAST ( VeryActiveMinutes AS FLOAT) VeryActiveMinutes,
	 CAST( FairlyActiveMinutes AS FLOAT)FairlyActiveMinutes,
	 CAST( LightlyActiveMinutes AS FLOAT) LightlyActiveMinutes,
	 CAST (SedentaryMinutes AS FLOAT) SedentaryMinutes,
	  Calories,
	  A.Day_of_Week,
	  TotalMinutesAsleep,
	  TotalTimeInBed ,
	  TotalSleepRecords

         from Daily_Activity A
		 INNER JOIN 
		 Sleep_day B
ON A.Id =B.Id AND A.ActivityDate= B.SleepDay

SELECT * FROM Daily_Activity_Sleep

--I Added a new Date column to hourlysteps 
select * from Hourlysteps_merged
		ALTER TABLE HourlySteps_merged
		ADD Date Date;
		UPDATE HourlySteps_merged
		SET date = CAST(ActivityHour AS DATE);

--I Added a new Time column to hourlysteps 
		ALTER TABLE HourlySteps_merged
		ADD TimeSteps time
		UPDATE HourlySteps_merged
		SET TimeSteps = CAST(ActivityHour AS TIME);
		SELECT * FROM hourlySteps_merged


		
