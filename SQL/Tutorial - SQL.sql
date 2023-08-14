/* selects everything from table */
select * from sales;

/* if you want to select specific columns*/
select SaleDate, Amount, Customers from sales;

/* Calculations ex amount per box  divides amount from boxes */
select SaleDate, Amount, Boxes, Amount / Boxes from sales;

/* Calculation and create a new column at the same time */

select SaleDate, Amount, Boxes, Amount / Boxes 'Amount per box' from sales;

/* another way select SaleDate, Amount, Boxes, Amount / Boxes as 'Amount per box' from sales */

 
 /* how many rows from tables are with more 10000 
 
 select count(*)  from sales
 where Amount > 10000
 
 */
 
  /* select specific conditions like filtering in Excel 
 
 select * from sales
 where amount > 10000
 */
 
 /* order of amount */
 
 select * from sales
 where amount > 10000
 order by amount desc; /* or asc */
 
 select * from sales
 where geoid ='g1' /* only getting the g1 items similar to filter and sort by in excel */
 order by PID, Amount desc;
 
 /* more complet where clause */
 
 select * from sales
 where amount > 10000 and SaleDate >= '2022-01-01' /* year format in sql YYYY-MM-DD */
 order by SaleDate asc;
 
 select SaleDate, Amount from sales
 where amount > 10000 and year(SaleDate) = 2022
 order by SaleDate asc; /* or you order by amount order by Amount desc; */

/* in between condition */ 

select * from sales
where Boxes >=0 and Boxes <= 50
order by Boxes desc; 

select * from sales
where boxes between 1 and 50
order by Boxes desc;

select SaleDate, Amount, Boxes, weekday(SaleDate)
from sales 
where weekday(SaleDate) = 4
order by Amount desc;

/* exploring the people table */

select * from people
where team = 'Delish' or team = 'Yummies';

/* using the in clause */ 

select * from people
where team  in ('Delish', 'Yummies');

/* Pattern matching */ 

select * from people 
where salesperson like '%B%'; /* everything that begins with the letter B or %B% to get everything B in the name  */

/* case operator */

select * from sales;

/* amount category as column with amount up to 1000 and between 1000 and 5000 and above 5000 create 3 labels */

select SaleDate, Amount,
	case when amount  < 1000 then 'Under 1k'
		 when amount < 5000 then 'Under 5k'
         when amount < 10000 then 'Under 10k'
	else '10k or more'
    end as 'Amount Category' /* the name of the new category */ 
from sales;


/* joins combine same data from different tables */

select * from sales;

select geo from geo;

select * from people;

/* join sales table with people table */ 

select s.saleDate, s.amount, p.Salesperson, s.SPID, p.SPID
from sales s
join people p on p.SPID = s.SPID; /* like a vlookup on excel, left join is the most common */

select s.saleDate, s.amount, pr.product
from sales s /* it can be anythin instead of s (it's shortcut for sales) */
left join products pr on pr.pid = s.pid;


/* join multiple tables */ 

select sales.SaleDate, sales.amount, p.Salesperson, pr.product, p.team
from sales sales
join people p on p.SPID = sales.SPID
join products pr on pr.pid = sales.pid; /* p = short for person pr = short of product you can have whatever name you like */ 


/* conditions with joins */ 

select sales.SaleDate, sales.amount, p.Salesperson, pr.product, p.team
from sales sales
join people p on p.SPID = sales.SPID
join products pr on pr.pid = sales.pid
where sales.amount < 500
and p.Team = 'Delish';

select sales.SaleDate, sales.amount, p.Salesperson, pr.product, p.team
from sales sales
join people p on p.SPID = sales.SPID
join products pr on pr.pid = sales.pid
where sales.amount < 500
and p.Team = ''; /* if is null not working then use '' to call the blanks rows */ 

/* filter with people from india or new zealand */

select sales.SaleDate, sales.amount, p.Salesperson, pr.product, p.team
from sales sales
join people p on p.SPID = sales.SPID
join products pr on pr.pid = sales.pid
join geo country on country.geoid = sales.geoid
where sales.amount < 500
and p.Team = ''
and country.Geo in ('New Zealand', 'India')
order by saleDate asc;


/* GROUP BY */ 

/* group by is like pivot table in excel */ 

select geoid, sum(amount), avg(amount), sum(boxes)
from sales
group by geoid; /* the total amount of each geography */ 


/* more detailed  group by */ 

select g.geo, sum(amount), avg(amount), sum(boxes)
from sales s
join geo g on s.geoid = g.geoid
group by g.geoid;


/* get data from people and product table */ 

select pr.category, p.team, sum(boxes), sum(amount) 
from sales s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid /* column pid from product table */ 
where p.team <> '' /* <> not equal */ /* eliminates the blanks */
group by pr.category, p.team
order by pr.category, p.team;

/* top 10 products */ 

select pr.Product, sum(s.amount) as 'Total Amount'
from sales s
join products pr on pr.pid = s.pid
group by pr.Product
order by 'Total Amount' desc
limit 10; 














































