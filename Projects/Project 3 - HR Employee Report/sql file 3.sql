-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SET GLOBAL sql_mode = '';
SELECT Gender, count(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
GROUP BY Gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race,COUNT(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
GROUP BY Race
ORDER BY count(*) DESC;
-- 3. What is the age distribution of employees in the company?
SELECT 
	min(Age) AS youngest,
    max(Age) AS oldest
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00';

SELECT
	CASE
		WHEN Age >=18 AND Age <=24 THEN '18-24'
        WHEN Age >=25 AND Age <=34 THEN '25-34'
		WHEN Age >=35 AND Age <=44 THEN '35-44'
        WHEN Age >=45 AND Age <=54 THEN '45-54'
        WHEN Age >=55 AND Age <=64 THEN '55-64'
        ELSE '65+'
     END AS Age_group,
     count(*) AS count
  FROM HR
  WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
  GROUP BY Age_group
  ORDER BY Age_group;
  
  SELECT
	CASE
		WHEN Age >=18 AND Age <=24 THEN '18-24'
        WHEN Age >=25 AND Age <=34 THEN '25-34'
		WHEN Age >=35 AND Age <=44 THEN '35-44'
        WHEN Age >=45 AND Age <=54 THEN '45-54'
        WHEN Age >=55 AND Age <=64 THEN '55-64'
        ELSE '65+'
     END AS Age_group, Gender,
     count(*) AS count
  FROM HR
  WHERE Age >= 18 AND Expiration_Date = '0000-00-00'  /*Condition*/
  GROUP BY Age_group, Gender
  ORDER BY Age_group, Gender;
        
-- 4. How many employees work at headquarters versus remote locations?

SELECT Location, count(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
GROUP BY Location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	round(avg(datediff(Expiration_date,Hire_date))/365,0) AS avg_length_employment
FROM HR
WHERE Expiration_date <= curdate() AND Expiration_date <> '0000-00-00' AND Age >=18; 

-- 6. How does the gender distribution vary across departments and job titles?
SELECT Department,Gender, count(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
GROUP BY Department,Gender
ORDER BY Department;

-- 7. What is the distribution of job titles across the company?

SELECT Job_Title,count(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_Date = '0000-00-00'
GROUP BY Job_Title
ORDER BY Job_Title DESC; 

-- 8. Which department has the highest turnover rate? the rate that each employer leave the company

/*calculate and creating new columns */

SELECT Department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate /* AS = save it to a new column*/
FROM (
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN Expiration_date <> '0000-00-00' AND Expiration_date <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM HR
    WHERE Age >= 18
    GROUP BY Department
    ) AS subquery
    ORDER BY termination_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?

SELECT State, count(*) AS count
FROM HR
WHERE Age >= 18 AND Expiration_date = '0000-00-00'
GROUP BY State
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT 
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100,2) AS net_change_percent
 
 /* the from is where you create the columns , select is what you want them to do*/
 
 FROM (
		SELECT YEAR(Hire_date) AS year, 
        count(*) AS hires,
        SUM(CASE WHEN Expiration_date <> '0000-00-00' AND Expiration_Date <= curdate() THEN 1 ELSE 0 END) AS terminations
        FROM HR
        WHERE Age >= 18
        GROUP BY YEAR(Hire_date)
 ) AS subquery
ORDER BY year ASC;     

-- 11. What is the tenure distribution for each department? /*how long they stay in each department*/

SELECT Department,round(avg(datediff(Expiration_date,Hire_date)/365),0) AS avg_tenure
FROM HR
WHERE Expiration_date <= curdate() AND Expiration_date <> '0000-00-00' AND Age >= 18
GROUP BY Department;


