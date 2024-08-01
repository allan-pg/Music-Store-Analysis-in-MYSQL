select * from customer;
select * from genre;
select * from employee;
select * from invoice;
select * from track;
select * from album;
select * from artist;
/* 1. write a query to return senior most employee  */
	   
select * from employee
where reports_to is null;

/*2. Which countries has the most invoices */

select billing_country, count(invoice_id) as number_of_invoices
from invoice
group by billing_country
order by count(invoice_id) desc;

/* 3. What are the top 3 values of total invoices */
select *
from invoice
order by total desc
limit 3;

/* Which city has the best customers?
write a query of city with highest sum of total invoices
Return the city name and  */ 
select billing_city, sum(total) as total_sum
from invoice
group by billing_city
order by total_sum desc
limit 1;

/*who is the best customer? customer who spends most money*/
select c.customer_id, 
      c.first_name, c.last_name, sum(i.total) as expenditure
from customer c
inner join invoice i using(customer_id)
group by c.customer_id
order by expenditure desc
limit 1;

-- Moderate Questions ------------------------------------------
-- Q1, Write a query to return email, first_name, last_name, and genre of all rock music
-- return your list alphabetically ordered from a

select C.email, c.first_name, c.last_name
from customer c
inner join invoice using(customer_id)
inner join invoice_line using(invoice_id)
inner join track using(track_id)
inner join genre g using(genre_id)
where g.genre_id = '1'
order by email asc;

-- Lets invite artists with the most rock music in our dataset.
-- Write a query to return artist name and tottal track of top rock bands
select a.artist_id, a.name, count(a.artist_id) as total_truck
from artist a
inner join album using(artist_id)
inner join track using(album_id)
where track_id in (
  select track_id
   from track
   inner join genre using(genre_id)
	where genre.name like 'Rock')
group by a.artist_id
order by total_truck desc
limit 10;

-- Return all track names with a song length that is greater than average length
-- return name and millisecond for each track order by song length with
-- longest song length
select name, milliseconds
from track
where milliseconds > (
	select avg(milliseconds)
	from track)
order by milliseconds desc;

-- -------------------Adavnced Questions--------------------------------------
/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
select c.customer_id,
 	   c.first_name,
       artist.name,    
       i.total as total
from customer c
inner join invoice i using(customer_id)
inner join invoice_line using(invoice_id)
inner join track using(track_id)
inner join album using(album_id)
inner join artist using(artist_id)
group by c.customer_id,artist.name,i.total
order by total desc;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

-- use a cte
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;
