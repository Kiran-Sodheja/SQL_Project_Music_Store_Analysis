Q1:Find how much amount spent by each customers on artists?Write a query to 
return customer name,artist name and total spent

with best_selling_artist as(
select artist.artist_id as artist_id,artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales 
from invoice_line
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by 1
order by 3 desc
limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc;

Q2:We want to find out the most popular music Genre for each country.We 
determine the most popular genre as the genre with the highest amount for 
purchases.Write a query that returns each country along with the top genre. 
For countries where the maximum number of purchases is shared return all Genres

with popular_genre as
(
 select count(invoice_line.quantity) as purchases,customer.country,genre.name,
genre.genre_id,
Row_number() over (partition by customer.country order by count(invoice_line.quantity)
desc)as rowno from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2 asc,1 desc
)
select * from popular_genre where rowno<=1

Q3:Write a query that determines the customer that has spent the most on music for 
each country.Write a query that returns the country along with the top customer and how 
much they spent.For countries where the top is shared,provide all customers who spent 
this amount

with recursive
customer_with_country as(
select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending
from invoice
join customer on customer.customer_id=invoice.customer_id
group by 1,2,3,4
order by 2,3 desc),

country_max_spending as(
select billing_country,max(total_spending)as max_spending from customer_with_country
group by billing_country)

select cc.billing_country,cc.total_spending,cc.first_name,cc.last_name,cc.customer_id
from customer_with_country cc
join country_max_spending ms
on cc.billing_country=ms.billing_country
where cc.total_spending=ms.max_spending
order by 1;