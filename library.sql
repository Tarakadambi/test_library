use library;

select * from employee;

select (levels)as catogery, last_name, first_name, city , hire_date from employee
order by levels desc;

# 1. Who are the top 3 senior employees based on job?

select * from employee;

select * from employee
order by levels desc
limit 3;

# 2 Which countries have the most invoice?

Select * from invoice;

select count(*)  as c , billing_country 
from invoice
group by billing_country
order by c desc;

# show 10 

select * from invoice;

select count(*)  as c , billing_country 
from invoice
group by billing_country
order by c desc
limit 10;


#3) what are top 5 values of total invoioce

select *from invoice;

select total from invoice
order by total 
limit 5;


# 4 Which 2 cities has the best customers? we would like to 
# throw a promotional music  festival in these 2 cities we
# made the most money. write a query that returns 2 cities 
# that has highest sum of invoice totals. return both city 
#  name and sum of all invoices totals.

select * from invoice;

select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc
limit 2;

# 5. who is the top 2 best customers?
# who has spent the most will  be declared as the best customers
#write a query that returns the top 2 customers who has spent the most.alter


select * from customer;

select customer.customer_id, customer.first_name, customer.last_name,
sum(invoice.total) as total
from customer
join invoice on customer.customer_id =invoice.customer_id
group by customer.customer_id
order by total desc
limit 2;

#6 Write a query to return email, first_name, last_name and genre of all 
# rock music listners. Return your list ordered alphabetically by email
# starting with A.

select * from customer;

select distinct email, first_name, last_name 
from customer
Join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice.invoice_id
where track_id in(
  select track_id from track
  join genre on track.genre_id = genre.genre_id
  where genre.name LIke 'rock'
  )
  order by email;
  
    
  # 7. let#s invite the srtists who have written the most rock music in 
  # our dataset. write a query that returns the srtist name and total track
  # count of top 8 rock bands.
  
  select * from artist;
  
  select artist.artist_id, artist.name, count(
  artist.artist_id) AS number_of_songs
  from track
  join album on album.album_id=track.album_id
  join artist on artist.artist_id =album.artist_id
  join genre on genre.genre_id =track.genre_id
    where genre.name like 'rock'
  group by artist.artist_id
  order by number_of_songs desc
  limit 8;

  # 8 Return all the track names 
  #that have a song han the average song length 
  #longer than the average song lenth.
  # Return the name and milliseconds for each track
  # order by song lenth with the longest songs listed first.
  
  select * from track;
  
  select name, milliseconds
  from track
  where milliseconds > (select avg(milliseconds)
  as avg_track_lenth
  from track)
  order by milliseconds desc;
  
    # find out most popular genre for each country.
  #determine most popular genre with highest amt of purchases.
  # country along with genre n max no. of purchases.
  
  select * from genre;
  
  # CT
  
  with popular_genre as
  (
  select count(invoice_line.quantity) as purchases, 
  customer.country, genre.name, genre.genre_id,
  row_number() over(partition by customer.country
  order by count(invoice_line.quantity)desc) as RowNo
  from invoice_line
   join invoice on invoice.invoice_id = invoice_line.invoice_id
   join customer on customer.customer_id = invoice.customer_id
   join track on track.track_id = invoice.customer_id
   join genre on genre.genre_id =track.genre_id
   group by 2,3,4
   order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <= 1;

# customer who has spent most on music for each country.
# country along with top 2 customers & spent by them.
# provide customers who spent the amount.

select * from customer;

#CT

with customer_with_country as 
(
 select customer.customer_id, first_name, last_name,
 billing_country, sum(total) as total_spending,
 Row_Number() over(partition by billing_country 
 order by sum(total) desc) as RowNo
 from invoice
 join customer on customer.customer_id = invoice.customer_id
 group by 1,2,3,4
 order by 4 asc, 5 desc)
 select * from customer_with_country where RowNo <= 1
