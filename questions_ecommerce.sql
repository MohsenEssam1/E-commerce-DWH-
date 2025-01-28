use e_commerce_dwh

-- When is the peak season of our ecommerce?
select top(1) quarter , year , count(order_id) count_order
from dim_date d join fact_sales f on d.datekey=f.order_date
group by quarter , year
order by count_order desc

-------------------------------------------
-- What time users are most likely to make an order or use the ecommerce app?

select top(1) order_time a , count(order_id) count_order
from fact_sales 
group by order_time
order by count_order desc

--------------------------------------------
-- What is the preferred way to pay in the ecommerce?
select top(1) payment_type  , count(Distinct o.order_id) count_order
from fact_sales f join dim_order o on f.order_id=o.order_id_sk
group by payment_type
order by count_order desc

--------------------------------------------
-- How many installments are usually done when paying in the ecommerce?

select top(1) isnull(payment_installments,1)  , count(Distinct o.order_id) count_order
from fact_sales f join dim_order o on f.order_id=o.order_id_sk
group by payment_installments
order by count_order desc

--------------------------------------------
-- What is the average spending time for users on our ecommerce?

select avg(ABS(order_time - order_approved_time) ) avg_time
from fact_sales

--------------------------------------------

-- Which logistic route has heavy traffic in our ecommerce?

SELECT top 1
    seller_city, 
    customer_city, 
    COUNT(*) AS route_count
FROM 
fact_sales f join Dim_seller s on f.seller_id = s.seller_id_sk 
join dim_customer o on o.customer_id_sk = f.customer_id
GROUP BY 
    seller_city, 
    customer_city
ORDER BY 
    route_count DESC;

------------------------------------------------
-- How many late-delivered orders are there in our ecommerce? 

SELECT 
    COUNT(CASE WHEN delivery_date > estimated_time_delivery THEN 1 END) AS late_delivered
FROM 
    fact_sales

------------------------------------------------
-- Are late orders affecting customer satisfaction? yes ... the most common score for the late deliverys is 1
SELECT fck.feedback_score, count(fck.feedback_score) as no_scores
FROM 
    fact_sales f join dim_order fck ON f.order_id= fck.order_id_sk
where 
	delivery_date > estimated_time_delivery
group by fck.feedback_score 
