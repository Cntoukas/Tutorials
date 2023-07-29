create database students;
use students;
create table college(
cName varchar(20) primary key,
state varchar(20),
enrollment int);
insert into college (cName, state, enrollment) values
('Standford', 'CA', 18000),
('MIT', 'MA', 10000),
('Berkeley', 'CA', 36000),
('Cornell', 'NY', 21000);

select * from college;

show tables;

create table students (
	ID integer primary key,
    sName varchar(20),
    GPA float);
    
insert into students (ID, sName, GPA) values
('123', 'Bob', '3.9'),
('232', 'Amy', '3.8'),
('564', 'Helen', '4.0'),
('678', 'Anna', '3.4');

select * from students;

create table application (
	ID integer primary key,
    cName varchar(20),
    major varchar(20),
    decision boolean);
  
    
insert into application (ID, cName, major, decision) values
	('123', 'Standford', 'CS', 'Y'),
    ('232', 'Berkeley', 'EE', 'N'),
    ('564', 'Cornell', 'CS', 'Y'),
    ('678', 'MIT', 'History', 'N');
    
select * from application;

/* changed the type of a column from application */ 

ALTER TABLE application
add column temp_decision varchar(10);

update application 
set temp_decision = case when decision = 1 then 'Yes' else 'No' end;

alter table application 
drop column decision;

alter table application
change column temp_decision decision varchar(10);


select * from application;

/* updates all rows to say the same thing */ 

update application 
set decision = 'Not Approved'
where decision = 'No';

/* update specific rows */

UPDATE application
SET decision = 'Approved'
WHERE ID IN (123, 564);

UPDATE application
SET decision = 'Not Approved'
WHERE ID IN (232, 678);


rename table students to pupils;

show tables;


/* asking questions */ 

select ID, sName, GPA
from students
where GPA > 3.5;

select sName, major
from pupils, application
where pupils.ID = application.ID;


/* adding more pupils to the table */ 

start TRANSACTION;

insert into pupils (ID, sName, GPA) values
	('343', 'Bob', 'GPA');
 
 insert into application (ID, cName, major) values
   ('343', 'Standford', 'CS');
 
 commit;
 
 select id from pupils;
 
 select id from application;

UPDATE pupils
SET GPA = '3.4'
WHERE ID IN (343);

/* removes duplicates */ 

select distinct sName, major
from pupils, application
where pupils.ID = application.ID;

/* updating a column */

select * from application;

update application
set decision = 'Approved'
where ID in (343);

select sName, GPA, decision
from pupils, application
where pupils.ID = application.ID
and major = 'CS' and cName = 'Standford';

/* adding the age column to the table pupils */ 

alter table pupils 
add column age int default 0;

select * from pupils;

update pupils 
set age = '20'
where ID in (123,343,564);

update pupils 
set age = '19'
where id in (232,678);

select * from pupils;

/* specify the name of a column from a specific table to avoid mixup the name if duplicat */ 

select distinct college.cName
from college, application
where college.cName = application.cName
and enrollment > 15000 and major = 'CS';

/* multiple queries at once */ 

select pupils.ID, sName, GPA, application.cName, enrollment
from pupils, college, application
where application.ID = pupils.ID and application.cName = college.cName
order by GPA desc, enrollment;


select * from pupils;

/* to query things from the same table you can you only the first letter of the table and add a number to it. ex pupils table = p so you can write it as p1 , p2 and so on */

select p1.ID, p1.sName, p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1 , pupils p2
where p1.gpa = p2.GPA and p1.ID < p2.ID; /* use < to find distinct values */ 

/* to unify columns from 2 differente table */ 

select cName as name from college /* as name to rename your new temp column */
union all /* use all to include duplicates */
select sName as name from pupils
order by name;

/* intersect operator the ID must have applied for 2 majors to return any results */

select ID from application where major = 'CS'
intersect
select ID from application where major = 'EE';

select distinct a1.ID
from application a1, application a2
where a1.ID = a2.ID and a1.major = 'CS' and a2.major = 'EE';

/* except operator like not equal difference operator */ 

select ID from application where major = 'CS'
except
select ID from application where major = 'EE';


/* colleges paired with the highest GPA of their applicants */
/* nested select and where clauses */ 

select distinct college.cName, state, GPA 
from college, application, pupils
where college.cName = application.cName
		and application.ID = pupils.ID
        and GPA >= all 
        (select GPA from pupils , application
        where pupils.ID = application.ID
        and application.cName = college.cName);

/* same with subquery */
    
  select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;  


/* join is the cross result of 2 tables */

select distinct sName, major 
from pupils inner join application /* inned join is the default operator in sql */
on pupils.ID = application.ID;

select sName, GPA 
from pupils join application 
on pupils.ID = application.ID
and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/* if we want to combine 3 conditions */

select application.ID, sName, GPA, application.cName, enrollment
from (application join pupils on application.ID = pupils.ID) join college
on application.cName = college.cName;

/* natural join of 2 tables by finding the same attribute names */ 
/* natural join eliminates duplicates */ 

select distinct sName, major
from pupils natural join application;


/* using clause you can use it for attributes that appear in both tables for example if the tables have the columns with the same name  */

select sName , GPA 
from pupils join application using(ID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/* for columns with same name that appear more than once */ 

select p1.ID, p1.sName , p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1, pupils p2
where p1.GPA = p2.GPA and p1.ID = p2.ID;


/* same with join operator */

select p1.ID, p1.sName , p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1 join pupils p2 using(GPA)
where p1.ID < p2.ID;


/* full outer join */ 

select sName, ID, cName, major
from pupils full  join application using(ID);


create database students;
use students;
create table college(
cName varchar(20) primary key,
state varchar(20),
enrollment int);
insert into college (cName, state, enrollment) values
('Standford', 'CA', 18000),
('MIT', 'MA', 10000),
('Berkeley', 'CA', 36000),
('Cornell', 'NY', 21000);

select * from college;

show tables;

create table students (
	ID integer primary key,
    sName varchar(20),
    GPA float);
    
insert into students (ID, sName, GPA) values
('123', 'Bob', '3.9'),
('232', 'Amy', '3.8'),
('564', 'Helen', '4.0'),
('678', 'Anna', '3.4');

select * from students;

create table application (
	ID integer primary key,
    cName varchar(20),
    major varchar(20),
    decision boolean);
  
    
insert into application (ID, cName, major, decision) values
	('123', 'Standford', 'CS', 'Y'),
    ('232', 'Berkeley', 'EE', 'N'),
    ('564', 'Cornell', 'CS', 'Y'),
    ('678', 'MIT', 'History', 'N');
    
select * from application;

/* changed the type of a column from application */ 

ALTER TABLE application
add column temp_decision varchar(10);

update application 
set temp_decision = case when decision = 1 then 'Yes' else 'No' end;

alter table application 
drop column decision;

alter table application
change column temp_decision decision varchar(10);


select * from application;

/* updates all rows to say the same thing */ 

update application 
set decision = 'Not Approved'
where decision = 'No';

/* update specific rows */

UPDATE application
SET decision = 'Approved'
WHERE ID IN (123, 564);

UPDATE application
SET decision = 'Not Approved'
WHERE ID IN (232, 678);


rename table students to pupils;

show tables;


/* asking questions */ 

select ID, sName, GPA
from students
where GPA > 3.5;

select sName, major
from pupils, application
where pupils.ID = application.ID;


/* adding more pupils to the table */ 

start TRANSACTION;

insert into pupils (ID, sName, GPA) values
	('343', 'Bob', 'GPA');
 
 insert into application (ID, cName, major) values
   ('343', 'Standford', 'CS');
 
 commit;
 
 select id from pupils;
 
 select id from application;

UPDATE pupils
SET GPA = '3.4'
WHERE ID IN (343);

/* removes duplicates */ 

select distinct sName, major
from pupils, application
where pupils.ID = application.ID;

/* updating a column */

select * from application;

update application
set decision = 'Approved'
where ID in (343);

select sName, GPA, decision
from pupils, application
where pupils.ID = application.ID
and major = 'CS' and cName = 'Standford';

/* adding the age column to the table pupils */ 

alter table pupils 
add column age int default 0;

select * from pupils;

update pupils 
set age = '20'
where ID in (123,343,564);

update pupils 
set age = '19'
where id in (232,678);

select * from pupils;

/* specify the name of a column from a specific table to avoid mixup the name if duplicat */ 

select distinct college.cName
from college, application
where college.cName = application.cName
and enrollment > 15000 and major = 'CS';

/* multiple queries at once */ 

select pupils.ID, sName, GPA, application.cName, enrollment
from pupils, college, application
where application.ID = pupils.ID and application.cName = college.cName
order by GPA desc, enrollment;


select * from pupils;

/* to query things from the same table you can you only the first letter of the table and add a number to it. ex pupils table = p so you can write it as p1 , p2 and so on */

select p1.ID, p1.sName, p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1 , pupils p2
where p1.gpa = p2.GPA and p1.ID < p2.ID; /* use < to find distinct values */ 

/* to unify columns from 2 differente table */ 

select cName as name from college /* as name to rename your new temp column */
union all /* use all to include duplicates */
select sName as name from pupils
order by name;

/* intersect operator the ID must have applied for 2 majors to return any results */

select ID from application where major = 'CS'
intersect
select ID from application where major = 'EE';

select distinct a1.ID
from application a1, application a2
where a1.ID = a2.ID and a1.major = 'CS' and a2.major = 'EE';

/* except operator like not equal difference operator */ 

select ID from application where major = 'CS'
except
select ID from application where major = 'EE';


/* colleges paired with the highest GPA of their applicants */
/* nested select and where clauses */ 

select distinct college.cName, state, GPA 
from college, application, pupils
where college.cName = application.cName
		and application.ID = pupils.ID
        and GPA >= all 
        (select GPA from pupils , application
        where pupils.ID = application.ID
        and application.cName = college.cName);

/* same with subquery */
    
  select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;  


/* join is the cross result of 2 tables */

select distinct sName, major 
from pupils inner join application /* inned join is the default operator in sql */
on pupils.ID = application.ID;

select sName, GPA 
from pupils join application 
on pupils.ID = application.ID
and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/* if we want to combine 3 conditions */

select application.ID, sName, GPA, application.cName, enrollment
from (application join pupils on application.ID = pupils.ID) join college
on application.cName = college.cName;

/* natural join of 2 tables by finding the same attribute names */ 
/* natural join eliminates duplicates */ 

select distinct sName, major
from pupils natural join application;


/* using clause you can use it for attributes that appear in both tables for example if the tables have the columns with the same name  */

select sName , GPA 
from pupils join application using(ID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/* for columns with same name that appear more than once */ 

select p1.ID, p1.sName , p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1, pupils p2
where p1.GPA = p2.GPA and p1.ID = p2.ID;


/* same with join operator */

select p1.ID, p1.sName , p1.GPA , p2.ID, p2.sName, p2.GPA
from pupils p1 join pupils p2 using(GPA)
where p1.ID < p2.ID;


/* full outer join */ 

select sName, ID, cName, major
from pupils full  join application using(ID); 

/* aggregations */ 

select avg(GPA)
from pupils;

select count(GPA)
from pupils;

select avg(GPA) 
from pupils, application
where pupils.ID = application.ID and major = 'CS';

/* to see how many applied to Cornell college */ 

select count(*)
from application 
where cName = 'Cornell';

/* number of applications to each college */ 

select cName, count(*)
from application 
group by cName;
