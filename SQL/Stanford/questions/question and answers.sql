/* Find the titles of all movies directed by Steven Spielberg. */ 

select title
from movie 
where director = 'Steven Spielberg';

/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */ 
SELECT DISTINCT year AS stars
FROM movie 
JOIN rating  ON movie.mID = rating.mID
WHERE stars IN (4, 5)
ORDER BY stars ASC;

/* Find the titles of all movies that have no ratings. */ 
select title 
from movie 
where movie.mID not in (select mID from rating);

/* Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */ 

select name
from reviewer, rating
where reviewer.rID = rating.rID and ratingDate is null;


/* Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.*/ 

select reviewer.name, movie.title, rating.stars, rating.ratingDate
from movie, reviewer, rating
where reviewer.rID = rating.rID and movie.mID = rating.mID
order by reviewer.name, movie.title, rating.stars; 

 /* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */ 
 
SELECT r.name AS reviewer_name, m.title AS movie_title
FROM rating r1
JOIN rating r2 ON r1.rID = r2.rID AND r1.mID = r2.mID
JOIN reviewer r ON r1.rID = r.rID
JOIN movie m ON r1.mID = m.mID
WHERE r1.stars < r2.stars AND r1.ratingDate < r2.ratingDate;

/* For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.*/


select m.title as movie_title, max(r.stars) as highest_stars
from movie m
join rating r on m.mID = r.mID
group by m.title
order by m.title;

/* For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */

select m.title as title, max(stars) - min(stars) as rating_spread
from movie m
join rating r on m.mID = r.mID
group by m.title
order by rating_spread desc, m.title;


select avg(stars)  as avg_rating, m.year as releasedate
from movie m
join rating r on m.mID = r.mID and m.year <= '1980' 
group by releasedate;

/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)*/

select avg(avg_rating_before) - avg(avg_rating_after) as avg_difference
/* this is the subquery first calulating the avg from before 1980 and then after 1980 and union it all*/ 
from ( select avg(stars) as avg_rating_before, null as avg_rating_after
from movie m
join rating r on m.mID = r.mID and m.year < 1980
group by m.mID

Union all 

select null as avg_rating_before, avg(stars) as avg_rating_after
from movie m 
join rating r on m.mID = r.mID and m.year >= 1980
group by m.mID
) as subquery;

















