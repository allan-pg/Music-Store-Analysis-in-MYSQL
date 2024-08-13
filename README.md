# Music Store Analysis in MYSQL
![image](https://github.com/user-attachments/assets/774a4402-5c96-45dc-8a9f-7b9a7dfe7fdf)

MySQL is a fast easy-to-use Relational Database Management System ( RDBMS ), which enables us to implement a database with tables, columns and indexes.
The database allows users to manipulate data using structural query language ( SQL ). SQL is the most popular language for adding, accessing and managing content in a database. Data is stored in tables and within tables, it’s stored in rows. 

# Table Of Contents 
1.0 Introduction  
1.1 Database and Tools  
1.2 Data Modelling   
1.3 Music store Data analysis  
1.4 Part 1 - Easy Questions  
1.5 Part 2 - Moderate Questions  
1.6 Part 3 - Advanced Queries  
1.7 References  

# 1.0 Introduction
This project is for beginners and will teach you how to analyze the music playlist database. You can examine the dataset with SQL and help the store understand its business growth by answering simple questions.

## 1.1 Database and Tools
- Postgre SQL
- PgAdmin4

## 1.2 Data Modelling  
Schema - Music Store Database  

![image](https://github.com/user-attachments/assets/dc513813-421c-4be9-92ec-c0a30a2c45f7)

## 1.3 Music store Data analysis 
I analysed music store database and came up with important findings from our database  
Lets dive into our SQL questions to solve. The quiz is arranged in form of:-
- Easy
- Moderate
- Hard
## Solved Questions
## 1.4 Part 1 - Easy Questions
1.Who is the senior most employee based on job title? 
```sql
select * from employee
where reports_to is null;
```

2. Which countries have the most Invoices?
```sql
select billing_country, count(invoice_id) as number_of_invoices
from invoice
group by billing_country
order by count(invoice_id) desc;
```

3. What are top 3 values of total invoice?
```sql
select *
from invoice
order by total desc
limit 3;
```
4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the 
   highest sum of invoice totals. Return both the city name & sum of all invoice totals.
```sql
select billing_city, sum(total) as total_sum
from invoice
group by billing_city
order by total_sum desc
limit 1;
```
5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
```sql
select c.customer_id, 
      c.first_name, c.last_name, sum(i.total) as expenditure
from customer c
inner join invoice i using(customer_id)
group by c.customer_id
order by expenditure desc
limit 1;
```
## 1.5 Part 2 - Moderate Questions 
1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
```sql
select C.email, c.first_name, c.last_name
from customer c
inner join invoice using(customer_id)
inner join invoice_line using(invoice_id)
inner join track using(track_id)
inner join genre g using(genre_id)
where g.genre_id = '1'
order by email asc;
```
2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
```sql
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
```  
3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the 
   longest songs listed first
 ```sql
select name, milliseconds
from track
where milliseconds > avg(milliseconds)
order by milliseconds desc;
```  
## 1.6 Part 3 - Advanced Queries
1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
```sql
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
```
2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query 
   that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
```sql
WITH RECURSIVE sales_per_country AS(
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
```
3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
```sql
WITH Customter_with_country AS (
		   SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
   		FROM invoice
   		JOIN customer ON customer.customer_id = invoice.customer_id
   		GROUP BY customer.customer_id,first_name,last_name,billing_country
   		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;
```
## 1.7 References

***www.youtube.com/@RishabhMishraOfficial***  
***Thank You :)***
