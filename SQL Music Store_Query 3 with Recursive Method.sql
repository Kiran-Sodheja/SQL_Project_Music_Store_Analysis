Q2:We want to find out the most popular music Genre for each country.We 
determine the most popular genre as the genre with the highest amount for 
purchases.Write a query that returns each country along with the top genre. 
For countries where the maximum number of purchases is shared return all Genres

with Recursive
sales_per_country as(
select count(*) as purchases_per_genre,customer.country,genre.name,genre.genre_id
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2
),
max_genre_per_country as(select max(purchases_per_genre)as max_genre_number,country
from sales_per_country
group by 2
order by 2)
select sales_per_country.* from sales_per_country
join max_genre_per_country on sales_per_country.country= max_genre_per_country.country
where sales_per_country.purchases_per_genre=max_genre_per_country.max_genre_number

*WITH CTE METHOD

Q3:Write a query that determines the customer that has spent the most on music for 
each country.Write a query that returns the country along with the top customer and how 
much they spent.For countries where the top is shared,provide all customers who spent 
this amount

With customer_with_country as(
select customer.customer_id,first_name,last_name,billing_country,sum(total) as 
total_spending,
row_number() over(partition by billing_country order by sum(total) desc)as rowno
from invoice
join customer on customer.customer_id=invoice.customer_id
group by 1,2,3,4
order by 4 asc,5 desc)
select * from customer_with_country where rowno<=1