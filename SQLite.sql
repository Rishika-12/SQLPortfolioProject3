
CREATE TABLE apple_table_united AS
SELECT * FROM appleStore_description1
union ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * from appleStore_description3
UNION ALL 
SELECT * from appleStore_description4

--Performing EDA
-- Finding unique apps in both tables 
SELECT COUNT(DISTINCT id) as UniqueId
from AppleStore

SELECT COUNT(DISTINCT id) as UniqueId
from apple_table_united

--finding if there is missing values
SELECT COUNT(*) as MissingVal
from AppleStore
WHERE track_name is NULL or user_rating is NULL or prime_genre is NULL

SELECT COUNT(*) as MissingVal
from apple_table_united
WHERE track_name is NULL or app_desc is NULL

--number of apps per genre
select prime_genre,COUNT(track_name) as countwithGenre
from AppleStore
GROUP BY prime_genre
ORDER by countwithGenre ASC

--overview of app rating
SELECT min(user_rating) as minimumrating, max(user_rating) as maximumrating, avg(user_rating) as averagerating
from AppleStore

--Data ANALYSIS 
--if paid apps or free apps have high avg rating
select CASE
when price>0 THEN 'Paid'
else 'Free'
END as app_type,
price,user_rating
FROM AppleStore

SELECT 
CASE
when price>0 THEN 'Paid'
else 'Free'
END as app_type,
avg(user_rating) as avgrating
from AppleStore
GROUP by app_type
ORDER BY avgrating

--apps with more supported lang have higher rating
SELECT Case 
WHEN lang_num < 10 Then 'less than 10 lang'
when lang_num BETWEEN 10 and 30 then '10-30 lang'
ELSE 'greater than 30 lang'
end as langcategory,
lang_num
FROM AppleStore

SELECT Case 
WHEN lang_num < 10 Then 'less than 10 lang'
when lang_num BETWEEN 10 and 30 then '10-30 lang'
ELSE 'greater than 30 lang'
end as langcategory,
avg(user_rating) as avgrating
FROM AppleStore
GROUP by langcategory
ORDER by avgrating

--genres with low rating 
SELECT prime_genre, avg(user_rating) as avgrating
from AppleStore
GROUP by prime_genre
ORDER by avgrating
LIMIT 10

--check if there is correlation bt app description and user rating
SELECT 
case when length(B.app_desc)<500 then 'Short'
when length(B.app_desc) BETWEEN 500 and 800 then 'Medium'
else 'Long' 
end as description_classification, avg(A.user_rating) as avgrating
from AppleStore as A
join apple_table_united as B
on A.id=B.id
GROUP by description_classification
order by avgrating

--find top rated apps for each genre 

SELECT prime_genre, track_name, user_rating
FROM
(
SELECT 
prime_genre,track_name,user_rating,
rank() over(partition by prime_genre ORDER by user_rating DESC,rating_count_tot DESC) as rnk
FROM AppleStore 
)
As a 
where a.rnk=1

SELECT prime_genre, rating_count_tot
FROM AppleStore