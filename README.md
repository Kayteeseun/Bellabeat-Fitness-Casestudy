# CASE STUDY:Bellabeat Fitness Analysis

INTRODUCTION:
This case study is part of the Google Data Analytics Professional Certificate.

I assumed to work as a Junior Data Analyst in Bellabeat marketing analytics team to focus on a Bellabeat product and analyze smart device usage data in order to gain insight into how people are using Bellabeat smart devices. 

To get the insight and trends of the dataset, I followed the six process of Data analyst. Ask, Prepare, Process, Analyze, Share, and Act to gain insight into how customers are using their smart devices and high-level recommendations on how these trends can inform Bellabeat marketing strategy.

SCENERIO:

Urška Sršen and Sando Mur founded Bellabeat, a high-tech manufacturer of health-focused products for women. Bellabeat is a successful small company, but they have the potential to become a larger player in the global smart device.
Since it was founded in 2013, Bellabeat has grown rapidly and quickly positioned itself as a tech-driven wellness company for women.
Collecting data on activity, sleep, stress, and reproductive health has allowed Bellabeat to empower women with knowledge about their own health and habits.
By 2016, Bellabeat had opened offices around the world and launched multiple products. Bellabeat products became available through a growing number of online retailers in addition to their own e-commerce channel on their website. 
Bellabeat company: https://bellabeat.com/

BellaBeat products 

○ Bellabeat app: The Bellabeat app provides users with health data related to their activity, sleep, stress, menstrual cycle, and mindfulness habits. This data can help users better understand their current habits and make healthy decisions.

○ Leaf: Bellabeat’s classic wellness tracker can be worn as a bracelet, necklace, or clip. The Leaf tracker connects to the Bellabeat app to track activity, sleep, and stress. 

○ Time: This wellness watch combines the timeless look of a classic timepiece with smart technology to track user activity, sleep, and stress. The Time watch connects to the Bellabeat app to provide you with insights into your daily wellness. 

○ Spring: This is a water bottle that tracks daily water intake using smart technology to ensure that you are appropriately hydrated throughout the day.

○ Bellabeat membership: Bellabeat also offers a subscription-based membership program for users. Membership gives users 24/7 access to fully personalized guidance on nutrition, activity, sleep, health and beauty, and mindfulness based on their lifestyle and goals.

1.	ASK: Identify the business task
	
a.	How can we make a better marketing strategy from trends in smart smart device usage?

b.	How could these trends apply to Bellabeat customers?


● Primary Stakeholders:

○ Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer.

○ Sando Mur: key member of the Bellabeat executive team. 

● Secondary Stakeholders: 

Bellabeat marketing analytics team: A team of data analysts responsible for collecting, analyzing, and reporting data that helps guide Bellabeat’s marketing strategy. 


2.	PREPARE
	
The data is  from kaggle  FitBit Fitness Tracker Data (CC0: Public Domain, dataset made available through Mobius): This Kaggle data set contains personal fitness tracker from thirty fitbit users.

Dataset link: https://www.kaggle.com/datasets/arashnic/fitbit. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits. 

Bias or credibility in this data; 

I followed the ROCCC steps to figure out the bias or credibility of the data.

	The dataset has limitations

•	Reliability; NOT Reliable. this data only comes from 30 randomly chosen people which is very low for the analysis out of 31 million who use FITBIT.  This would mean a confidence level of 95% or 90% and a margin of error of 15%, which is not reliable and inconclusive.It would be great to survey or test using sample of the larger population. 
All the data collected was just a month, which is not long enough to find the accurate and reliable trends. 

•	Original: Data is sourced from a third-party survey by Amazon Mechanical Turk. 

•	Comprehensive: Not comprehensive.  The data are not complete they are missing information that would have helped make a more accurate analysis like age, height etc. 

•	Current: Not current. Data is from March 2016 to May 2016. It is outdated as fitness trackers might have changed.

•	Cited: HIGH. The data is cited and well documented.


I decided to used 6 files out of the 18 csv files to carry out my analysis includes; DailyActivity, DailySteps, DailyCalories, SleepDay, MinuteSleep and Weightloginfo

Process 
The cleaning and the analysis process,I used Microsoft SQL server for the data cleaning and analysis. I also used PowerBI tool for the data visual.
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

Checking of duplicate values on each table

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
		No duplicate found

		select id, Date from hourlySteps_merged
		GROUP BY ID, Date
		HAVING COUNT (*) >1

--3 Duplicates removed from Sleep_day table

		;with cte as (select Id, SleepDay,TotalSleepRecords,
		row_number() over (partition by id, sleepday, totalsleeprecords 
		order by id,sleepday, totalsleeprecords) rownum from Sleep_day)
		Delete from cte where rownum > 1

I Added DayofWeek column to both daily_activity and sleepday table

		ALTER TABLE Daily_Activity
		ADD Day_of_Week char(10)

		ALTER TABLE Sleep_day
		ADD Day_of_Week char(10)


--Updating weekday to the DayofWeek column I just created. 

		UPDATE Daily_activity
		SET Day_of_week = daTEname(WEEKDAY,ActivityDate)

		UPDATE Sleep_day
		SET Day_of_Week =daTEname(WEEKDAY,SleepDay)

I created a new table adding dailyactivity and sleep day to do some analysis based on the new column I just added to both.

		create table Daily_Activity_Sleep
		(Id float, ActivityDate DATETIME2 (7), TotalSteps INT, TotalDistance FLOAT , VeryActiveDistance Float , ModeratelyDistance FLOAT,
		LightActiveDistance Float, SedentaryActiveDistance FLOAT , VeryActiveMinutes FLOAT, FairlyActiveMinutes FLOAT , 
		LightlyActiveMinutes FLOAT, SedentaryMinutes FLOAT, Calories FlOAT, Day_Of_Week CHAR(10),TotalMinutesAsleep FLOAT,
		TotalTimeInBed FLOAT,TotalSleepRecords INT)

		INSERT INTO Daily_Activity_Sleep
		(ID, ActivityDate, TotalSteps, TotalDistance,VeryActiveDistance, ModeratelyDistance, LightActiveDistance, SedentaryActiveDistance, 
		VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories, Day_Of_Week,TotalMinutesAsleep,TotalTimeInBed ,TotalSleepRecords)

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


I Added a new Date column to hourlysteps 

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
					
		
3.	ANALYZE AND SHARE
		
--Total Weekly Activity

			select Day_of_week,
			round(SUM(Calories), 0) AS TotalCalories,
			round(SUM(TotalDistance), 2) AS TotalDistance,
			round(SUM(Totalsteps),2) AS TotalSteps
			from Daily_Activity_Sleep 
			GROUP BY  Day_of_week



![2023-06-10 (58)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/7e7c0472-8855-41d3-9abd-b346602c7d8b)





   -- Average Weekly Activity
   
			select Day_of_week,
			round(AVG(Totalsteps),2) AS Avg_steps,
			round(AVG(TotalDistance), 2) AS Avg_distance,
			round(AVG(Calories), 0) AS Avg_calories
			from Daily_Activity_Sleep
			GROUP BY  Day_of_week
			


![2023-06-10 (45)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/2ae0fce1-3342-42ef-b4a6-7855307be05b)



--Total Time Spent on each Activity per Day

			select distinct Day_Of_Week,
			SUM(VeryActiveMinutes) AS very_active_mins,
			SUM(LightlyActiveMinutes) AS lightly_active_mins,
			sum(SedentaryMinutes) AS sedentary_mins,
			SUM(FairlyActiveMinutes) AS fairly_active_mins
			from Daily_Activity_Sleep
			Where TotalTimeInBed is not null
			GROUP BY Day_Of_Week
                       
		       
![2023-06-10 (37)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/44e18c30-4e21-440f-8ad4-131b12aa9164)
		       

				
				
				
 --Total_active_duration and calories burned
 
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

			
			
			
![2023-06-10 (64)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/ee51cf78-a9d9-470f-8312-27300d135c8d)




		



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
		 


  ![2023-06-10 (67)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/8bd733db-4bb7-4908-809a-089fedac3f5c)




--Percentage of Total Time spent on Each Acitivity Per Day
		
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
	
	
	
	
 ![2023-06-10 (28)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/8ec11e59-fab2-45ed-8d1b-5a8b812c5c17)
	
	
	
	
	
	
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
		

 --Users_type categorize of dailysteps
 
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
			


--Total users count and percentage of different types of users based on average



		select User_Type, count(ID) AS Total_Users, 
		CONCAT(ROUND(CAST(count(ID)AS FLOAT)/24*100,1),'%') as  User_Percentage
		FROM user_categorize_avg_daily_steps
		GROUP BY User_Type
		ORDER BY User_Percentage DESC;
		

![2023-06-10 (69)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/707961f7-3ac8-49cc-9c0b-6dd24da7fe08)

    


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
			
			
			
			
 ![2023-06-10 (34)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/4b089f3e-1cf4-4038-a030-df33216a0947)




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
			
			
			
			
  ![2023-06-10 (54)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/dfb300e9-cbb2-4042-9891-1e5fa0a8614c)




--Relationship between sleepmin,TimespentinBed and Calories

			SELECT ID, 
			SUM(TotalMinutesAsleep) AS total_sleep_mins, 
			SUM(TotalTimeInBed) AS total_time_in_bed,
			SUM(Calories) AS total_calories
			FROM Daily_Activity_Sleep
			Group by ID  
			
			
			
 ![2023-06-10 (33)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/bf91e089-022c-43b5-bc02-77e432fa9ab6)
			
			

			
			
		
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
		
		

![2023-06-10 (56)](https://github.com/Kayteeseun/ThedatagirlProject.github.io/assets/132163855/4b91fe9a-4838-4a26-8390-d919eb0571f4)




		
ACT PHASE
RECOMMENDATIONS
 
1.	Analysis on daily steps; I got my findings from the recommendation of Centre disease control CDC. CDC recommend at least 8000 – 10000 steps a day, it is also found that at least 15000 steps per day is correlated to lower metabolic syndrome. But if 15000steps seems like a lofty goal, 10000 steps will help them improve their mood and fitness level. So, I calculated the users’ steps using the 10000 in a day. Analysis shows that 38% of users only walk between that daily mark. Most users spend their time on Sedentary, Walking has been reported as the common mode of physical activity. Bellabeat needs to improve through notifications so users will put more effort in their daily steps and also notify them on holidays period.


2.	It also shows that users only walk most on Saturday and during the week Monday, Tuesday which is obvious that users might have to go to work. Users’ daily steps on Sunday is low to other days. Companies needs to create an awareness through blogs and send to their emails to lecture them how important daily steps is and how It is to know the exact average of steps to take in a day based on the 
factors such as age and diet. This data does not include their age so it’s not conclusive.


3.	Users spend more of their time on sedentary. Living a sedentary lifestyle, the higher of being overweight, develop diabetes or heart disease, and experience depression and anxiety. Not enough physical activity as lot of negative effects to the health. 73% of users spend their daily activity on sedentary. Bellabeat can create an app for users to sneak more physical activity into their daily routine and sedentary behavior through fitness tracker.


4.	Analysis on Calories; According to the Dietary guidelines for Americans, the average adult’s woman expands roughly 1,600 to 2000 calories per day. From my analysis here it shows that almost 60% of users follow that average recommend calories per day. Daily steps and Calories correlate together. The more steps they take the more calories to be burned, Companies can also motivate users to improve in their daily steps to change their lifestyle from sedentary to other activities.


5.	Analysis on Sleep Day: For optimum health and function, the average adult should get seven to nine hours of sleep overnight. Users are not sleeping at least 8 hours a day which is recommended and it can be linked to many chronic health problems. Users used most of their time wasted on bed. By creating a health-conscious content in their smart devices related to sleep will let users get insight into their sleep habits and know how sleep is so important.

Thank You.
