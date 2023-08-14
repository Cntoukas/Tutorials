/* uses the projects database */
use projects;

/* selects all the columns from HR table*/
select*from HR;

/* changes the name and the type of the column*/

alter table HR
change column ï»¿id emp_id varchar(20) null;

/* change the name of the column emp_id to Employer_ID and other columns*/
Alter table HR
rename column emp_id to Employer_ID;

Alter table HR
rename column first_name to First_Name;

alter table HR
rename column last_name to Last_Name;

alter table HR
rename column Birth_Date to Birthdate;

alter table HR
rename column gender to Gender;

alter table HR 
rename column race to Race;

alter table HR
rename column department to Department;

alter table HR
rename column jobtitle to Job_Title;

alter table HR
rename column location to Location;

alter table HR
rename column hire_date to Hire_date;

alter table HR
rename column termdate to Termination_Date;

alter table HR
rename column location_city to City;

alter table HR 
rename column location_state to State;

/* gives you the data tyoes of the table*/

describe HR;
/*selects a column birthdate from table hr*/

select birthdate from HR;

/* removes the safety measures of sql to write the primarey key*/
SET sql_safe_updates = 0;

/*changes the format of the dates */
UPDATE HR
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

alter table HR
MODIFY COLUMN birthdate DATE;

UPDATE HR
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SET sql_mode = ' ';   

ALTER TABLE HR
MODIFY COLUMN hire_date DATE;

UPDATE HR
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

ALTER TABLE HR
MODIFY COLUMN termdate DATE;

/* adds a new column named AGE as an integer */
ALTER TABLE HR ADD COLUMN age INT;

/* update modifies the records of a table*/

/*In summary, this code updates the "age" column in the "HR" table by calculating the age based on the difference between the "Birthdate" column and the current date.*/

update HR
SET age = timestampdiff(YEAR, Birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM HR;

/* timestamp 26.22*/
