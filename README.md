# Music Store Analysis in MYSQL
![image](https://github.com/user-attachments/assets/b18e3bd5-d72d-480c-ae6c-2294c5a68730)

MySQL is a fast easy-to-use Relational Database Management System ( RDBMS ), which enables us to implement a database with tables, columns and indexes.
The database allows users to manipulate data using structural query language ( SQL ). SQL is the most popular language for adding, accessing and managing content in a database. Data is stored in tables and within tables, it’s stored in rows.  
# Introduction
This project is for beginners and will teach you how to analyze the music playlist database. You can examine the dataset with SQL and help the store understand its business growth by answering simple questions.

## Database and Tools
- Postgre SQL
- PgAdmin4

## Data Modelling  
Schema - Music Store Database  

![image](https://github.com/user-attachments/assets/dc513813-421c-4be9-92ec-c0a30a2c45f7)

## Music store Data analysis 
I analysed music store database and came up with important findings from our database  
Lets dive into our SQL questions to solve. The quiz is arranged in form of:-
- Easy
- Moderate
- Hard
## Solved Questions
1.Who is the senior most employee based on job title? 
```
select * from employee
where reports_to is null;
```

2. Which countries have the most Invoices?
```
select billing_country, count(invoice_id) as number_of_invoices
from invoice
group by billing_country
order by count(invoice_id) desc;
```

3. What are top 3 values of total invoice?
```
select *
from invoice
order by total desc
limit 3;
```
 

