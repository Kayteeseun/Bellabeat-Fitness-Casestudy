---- Total Weekly Activity
		select Day_of_week,
		round(SUM(TotalDistance), 2) AS TotalDistance,
		round(SUM(Calories), 0) AS TotalCalories,
		round(SUM(Totalsteps),2) AS TotalSteps
		from Daily_Activity_Sleep 
		GROUP BY  Day_of_week
--Average Weekly Activity
		select Day_of_week,
		round(AVG(TotalDistance), 2) AS Avg_distance,
		round(AVG(Calories), 0) AS Avg_calories,
		round(AVG(Totalsteps),2) AS Avg_steps
			from Daily_Activity_Sleep
		GROUP BY  Day_of_week
--Time spent on activity per day
		select distinct id,
		SUM(VeryActiveMinutes) AS very_active_mins,
		SUM(LightlyActiveMinutes) AS lightly_active_mins,
		sum(SedentaryMinutes) AS sedentary_mins,
		SUM(FairlyActiveMinutes) AS fairly_active_mins
		from Daily_Activity_Sleep
		Where TotalTimeInBed is not null
		GROUP BY  ID
--Total Time Spent on each Activity per Day
		select distinct Day_Of_Week,
		SUM(VeryActiveMinutes) AS very_active_mins,
		SUM(LightlyActiveMinutes) AS lightly_active_mins,
		sum(SedentaryMinutes) AS sedentary_mins,
		SUM(FairlyActiveMinutes) AS fairly_active_mins
		from Daily_Activity_Sleep
		Where TotalTimeInBed is not null
		GROUP BY Day_Of_Week

		--total_active_duration and calories burned
		select  ID,
		round(sum(Totalsteps),2) AS TottalSteps,
		round(sum(VeryActiveMinutes), 0) AS total_very_active_mins,
		round(sum(FairlyActiveMinutes),2) AS Total_fairly_active_mins,
		round(sum(SedentaryMinutes),2) AS Total_sendentary_mins,
		ROUND(SUM(LightlyActiveMinutes),2) AS Total_lightly_active_mins,
		ROUND(SUM(Calories),2) AS Total_calories
		from Daily_Activity_Sleep 
		Where TotalTimeInBed is not null
		GROUP BY  ID

--Total Minutes each User spent on each activity per day
		select  ID,
		ROUND(AVG(Totalsteps),2) AS TottalSteps,
		ROUND(AVG(VeryActiveMinutes), 0) AS total_very_active_mins,
		ROUND(AVG(FairlyActiveMinutes),2) AS Total_fairly_active_mins,
		ROUND(AVG(SedentaryMinutes),2) AS Total_sendentary_mins,
		ROUND(AVG(LightlyActiveMinutes),2) AS Total_lightly_active_mins,
		ROUND(AVG(Calories),2) AS Total_calories
		from Daily_Activity_Sleep 
		Where TotalTimeInBed is not null
		GROUP BY  ID

--Count Total of Frequency_of_Usage In Daily_Activity
		

	      SELECT ID, COUNT(ID) AS Total_Usage_In_Days
		 INTO Frequency_of_Usage 
		FROM Daily_Activity_Sleep
		GROUP BY ID
		SELECT * FROM  Frequency_of_Usage

-- I create a new table to get the category of each user based on their frequent use.
	
		SELECT ID, Total_Usage_In_Days,
		CASE 
		WHEN (Total_Usage_In_Days >=1 AND Total_Usage_In_Days<=10) THEN 'Low Use'
		WHEN (Total_Usage_In_Days >=11 AND Total_Usage_In_Days<=20) THEN 'Moderate Use'
		WHEN (Total_Usage_In_Days >=21 AND Total_Usage_In_Days<=31) THEN 'High Use'
		END AS 'Type_Of_Usage'
		INTO user_category_by_usage_in_days
		 FROM Frequency_of_Usage;
		 		 SELECT * FROM  user_category_by_usage_in_days

		 --Percentage of users based on use of app in days
		 select Type_Of_Usage,CONCAT(CAST(count(ID)as FLOAT)/24*100, '%') AS percentage
		 from user_category_by_usage_in_days A
		 group by Type_Of_Usage
		 

--Percentage of Total Time spent on Each Acitivity Per Day
		select * from Daily_activity
		SELECT
       Day_of_Week,
concat(round(sum(VeryActiveMinutes)/sum(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)*100, 2)
, '%') AS VeryActiveMinutes,
concat(round(sum(FairlyActiveMinutes)/sum(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)*100, 2)
, '%') AS FairlyActiveMinutes,
concat(round(sum(LightlyActiveMinutes)/sum(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)*100, 2)
, '%') AS LightlyActiveMinutes,
concat(round(sum(SedentaryMinutes)/sum(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)*100, 2)
, '%') SedentaryMinutes
FROM
Daily_Activity_Sleep
GROUP BY Day_of_Week;

--I created a temporary table to get the user avg daily steps to carry out analysis 

	SELECT id, round(avg(TotalDistance), 2) AS Avg_Distance, 
	round(avg(TotalSteps), 2) AS Avg_Daily_Steps, 
	round(avg(TotalMinutesAsleep), 0) AS Avg_Sleep,
	round(avg(Calories), 0) AS Avg_Calories
	 INTO AveragebyUsers
	FROM
	Daily_Activity_Sleep
	GROUP BY id
	select * from AverageByUsers

	--users_type categorize of dailysteps
		SELECT 
		CAST(id AS FLOAT)AS ID, AVG_Daily_Steps,
		CASE
		WHEN AVG_Daily_Steps < 5000 THEN 'Sedentary'
		WHEN AVG_Daily_Steps >= 5000 AND AVG_Daily_Steps < 7499 THEN 'Slightly Active'
		WHEN AVG_Daily_Steps >= 7500 AND AVG_Daily_Steps < 9999 THEN 'Fairly Active'
		WHEN AVG_Daily_Steps >= 10000 THEN 'Very Active'
		END AS User_Type
		INTO user_categorize_avg_daily_steps
		FROM averagebyusers;
		SELECT * FROM user_categorize_avg_daily_steps
		
--TOTAL USERS COUNT AND PERCENTAGE  OF DIFFERENT TYPES OF USERS BASED ON AVERAGE
select User_Type, count(ID) AS Total_Users, 
CONCAT(ROUND(CAST(count(ID)AS FLOAT)/24*100,1),'%') as  User_Percentage
FROM user_categorize_avg_daily_steps
GROUP BY User_Type
ORDER BY User_Percentage DESC;

SELECT 
		CAST(id AS FLOAT)AS ID, Avg_Calories,
		CASE
		WHEN Avg_Calories < 1000 THEN 'Sedentary'
		WHEN Avg_Calories >= 1000 AND Avg_Calories < 1599 THEN 'Slightly Active'
		WHEN Avg_Calories >= 1600  AND Avg_Calories < 2599 THEN 'Fairly Active'
		WHEN Avg_Calories >= 2600 THEN 'Very Active'
		END AS User_Type
		INTO User_Type_Calories
		FROM averagebyusers;
		Select * from User_Type_Calories

		select User_Type, count(ID) AS Total_Users, 
CONCAT(ROUND(CAST(count(ID)AS FLOAT)/24*100,1),'%') as  User_Percentage
FROM  User_Type_Calories
GROUP BY User_Type
ORDER BY User_Percentage DESC;

--Total avg sleep time per users
		SELECT ID,AVG(TotalMinutesAsleep)/ 60 AS avg_sleep_hour,
		AVG(TotalTimeInBed)/ 60 AS avg_time_bed,
		AVG(TotalTimeInBed-TotalMinutesAsleep) AS time_wasted_in_bed
		FROM Sleep_day
		GROUP BY Id
--Relationship between DailySteps and Minutes
		SELECT ID, 
		SUM(TotalMinutesAsleep) AS total_sleep_mins, 
		SUM(TotalTimeInBed) AS total_time_in_bed,
		SUM(TotalSteps) AS total_steps
		FROM Daily_Activity_Sleep
		Group by  ID

--Relationship between sleepmin,TimespentinBed and Calories
		SELECT ID, 
		SUM(TotalMinutesAsleep) AS total_sleep_mins, 
		SUM(TotalTimeInBed) AS total_time_in_bed,
		SUM(Calories) AS total_calories
		FROM Daily_Activity_Sleep
		Group by ID
--Body Mass Index Checked
		SELECT
	CAST(id AS FLOAT)AS ID, 
   ROUND(AVG(WeightKg),0) AS avgweight,
    CASE
		WHEN bmi < 18.5 THEN 'underweight'
        WHEN bmi BETWEEN 18.5 AND 25 THEN 'normalweight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'overweight'
        WHEN bmi >= 30 THEN 'obesity'
	END AS body_mass_index
	 INTO weightkg_type
FROM WeightLogInfo
GROUP BY Id,CASE
		WHEN bmi < 18.5 THEN 'underweight'
        WHEN bmi BETWEEN 18.5 AND 25 THEN 'normalweight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'overweight'
        WHEN bmi >= 30 THEN 'obesity'
	END ;
select * from weightkg_type

--percentage of avgweight users
SELECT 
	A.Id,
   B.avgweight,
    B.body_mass_index,fat,
   CONCAT(ROUND(CAST(count(A.Id)AS FLOAT)/8*100,1),'%') as  User_Percentage
FROM WeightLogInfo A
INNER JOIN weightkg_type B
On A.Id = B.ID

GROUP BY A.Id,B.avgweight,body_mass_index,
    fat;