-- 15 business questions

--1. count the number of movies vs tv shows

select type,
    count(*) as total_content
from netflix
group by type;


--2. find the most common rating for movies and tv shows

select 
   type ,rating
from    
(
select 
  type,rating, count(*) as rating_count,
  rank() over(partition by type order by count(*) desc ) as ranking
from netflix
group by rating, type
) as t1

where ranking =1;



--3. list all movies released in a specific year

select
  * from netflix
where type='Movie' and release_year='2020';  


--4.) find the top 5 countries with the most contents on netflix.

select 
  unnest(string_to_array(country,',')) as new_country,
  count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;


-- 5.) identify the longest movie

select * from netflix
  where  type='Movie'
  and duration=(select max(duration) from netflix);


--6.)  find content added in the last 5 yrs.

select *
from netflix
  where 
    to_date(date_added, 'Month DD, YYYY')>= current_date-interval '5 years';
  

--7.) find all the movies / Tv shows by director 'rajiv chilaka'

select * from netflix
where director ilike '%Rajiv Chilaka%';



--8.) List all tv shows with more than 5 seasons

select *  from netflix
where type = 'TV Show' and  split_part(duration, ' ',1)::numeric>5;


--9.)  count the number of content items in each genre


select 
  unnest(string_to_array(listed_in,',')) as genre,
  count(show_id) as total_content
from netflix
group by 1;


-- 10.)  find each year and the average number of contents release by india on net flix,
--   return top 5 years with highest avg content release.

select  
   extract(year from to_date(date_added,'Month DD,YYYY')) as year,
   count(*),
   round(
        count(*) ::numeric/(select count(*) from netflix where country='India'):: numeric *100,2) as avg_content_per_year
from netflix		
where country='India'
group by 1
order by 2 desc
limit 5;


--- 11.) list all the movies have documentaries

select * from netflix
where listed_in ilike '%documentaries%';

---- 12.) find all the content without director.

select * from netflix
where director is null;


--13.) find how many moviesactor 'salman khan' appeared in last 10 yrs

select * from netflix
where casts ilike '%salman khan%'
and release_year > extract(year from current_date) - 10;


---- 14.) find the top 10 actors who appeared in the highest number of movies produced in india

select
  unnest(string_to_array(casts,',')) as actors,
  count(show_id) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10;


--- 15.)  find all the movies and shows having keyword 'kill' or ' voilence' then categorize them as bad content and rest as good content

with new_table
as(
select *,  case
    when description ilike '%kill%' or
	 description ilike '%voilence%' then 'bad content'
	 else 'good content'
	end category
	
from netflix
	
)

select category, count(*) as total_content
from new_table
group by 1;


















  