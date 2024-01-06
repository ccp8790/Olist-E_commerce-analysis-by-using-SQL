USE Brizillian_Ecommerce;
SELECT 
    cp.customer_unique_id,
    cp.order_id,
    cp.payment_value,
    SUM(cp.payment_value) OVER (
        PARTITION BY cp.customer_unique_id ORDER BY cp.order_date
    ) AS cumulative_spend
FROM
(
    SELECT 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp AS order_date,
        p.payment_value
    FROM 
        customers_dataset c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_payments p ON o.order_id = p.order_id
) AS cp -- Alias for the subquery
ORDER BY 
    cp.customer_unique_id, 
    cp.order_date;


--  Identify purchasing frequency

SELECT 
    customer_unique_id,
    order_id,
    order_date,
    DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_unique_id ORDER BY order_date)) AS days_since_last_order
FROM 
    (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp AS order_date
    FROM 
        customers_dataset c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    ) AS order_dates;
    
    
-- repeate purchase behavior, repeate percentage? 
    
    SELECT 
    customer_unique_id,
    COUNT(order_id) AS total_orders,
    MIN(order_date) AS first_purchase_date,
    MAX(order_date) AS last_purchase_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS days_between_first_and_last_order,
    ROUND(AVG(days_since_last_order), 1) AS average_days_between_orders
FROM 
    (
    SELECT 
        customer_unique_id,
        order_id,
        order_date,
        DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_unique_id ORDER BY order_date)) AS days_since_last_order
    FROM 
        (
        SELECT 
            c.customer_unique_id,
            o.order_id,
            o.order_purchase_timestamp AS order_date
        FROM 
            customers_dataset c
        JOIN 
            orders o ON c.customer_id = o.customer_id
        ) AS order_dates
    ) AS order_intervals
GROUP BY 
    customer_unique_id
HAVING 
    COUNT(order_id) > 1;
    
-- Average order value per customer     
SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    (SUM(p.payment_value) / COUNT(o.order_id)) AS average_order_value
FROM 
    customers_dataset c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_payments p ON o.order_id = p.order_id
GROUP BY 
    c.customer_unique_id;

-- repeate purchase customers: order numbers, days interval, AOV
 SELECT 
	a.customer_unique_id
    ,a.total_orders
    ,a.days_between_first_and_last_order
    ,a.average_days_between_orders
    ,b.average_order_value
FROM
	(SELECT 
    customer_unique_id,
    COUNT(order_id) AS total_orders,
    MIN(order_date) AS first_purchase_date,
    MAX(order_date) AS last_purchase_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS days_between_first_and_last_order,
    ROUND(AVG(days_since_last_order), 1) AS average_days_between_orders
FROM 
    (
    SELECT 
        customer_unique_id,
        order_id,
        order_date,
        DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_unique_id ORDER BY order_date)) AS days_since_last_order
    FROM 
        (
        SELECT 
            c.customer_unique_id,
            o.order_id,
            o.order_purchase_timestamp AS order_date
        FROM 
            customers_dataset c
        JOIN 
            orders o ON c.customer_id = o.customer_id
        ) AS order_dates
    ) AS order_intervals
GROUP BY 
    customer_unique_id
HAVING 
    COUNT(order_id) > 1
    ) AS a
JOIN
	(
    SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    ROUND((SUM(p.payment_value) / COUNT(o.order_id)),2) AS average_order_value
FROM 
    customers_dataset c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_payments p ON o.order_id = p.order_id
GROUP BY 
    c.customer_unique_id
    ) AS b ON a.customer_unique_id = b.customer_unique_id;
	
-- check if the oerder value equal to the payment value by order id; no cost and profit
SELECT 
tov.total_order_value,
op.payment_value
FROM
(
SELECT 
	order_id,
    ROUND(order_item_id * (price + freight_value),2) AS total_order_value
FROM order_items oi
) AS tov
JOIN order_payments op
	ON op.order_id = tov.order_id;

-- what kind of product I can sell?
-- get the popular product category by order numbers 
-- get the popular product category by total revenue


-- product english name, product populor categories, product with high sales revneue categories

SELECT 
	pcn.product_category_name
    ,pt.product_category_name_english
    ,pcn.total_revenue
    ,pcn.total_order_number
FROM 
(
SELECT 
	-- pt.product_category_name_english
    p.product_category_name
    ,SUM(pv.payment_value) AS total_revenue
    ,COUNT(pv.order_id) As total_order_number
FROM
(
SELECT 
	op.order_id
    ,oi.product_id
    ,op.payment_value
FROM order_items oi
LEFT JOIN order_payments op
	ON oi.order_id = op.order_id
) AS pv
LEFT JOIN products p
	ON p.product_id = pv.product_id
GROUP BY p.product_category_name
) as pcn
RIGHT JOIN product_category_name_translation pt
	ON pcn.product_category_name = pt.product_category_name
ORDER BY pcn.total_revenue DESC, pcn.total_order_number DESC;   

-- Cancellation rate
SELECT 
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) / COUNT(*) AS cancellation_rate
FROM orders;
-- cancellation rate is 0.0063, 0.63%

-- Yearly, Monthly, Weekly sales pattern
SELECT 
	YEAR(order_purchase_timestamp) AS year
	,MONTH(order_purchase_timestamp) AS month
    ,WEEK(order_purchase_timestamp) AS week
	,COUNT(*) AS total_orders
    ,ROUND(SUM(op.payment_value),2) AS total_revenue
FROM orders
JOIN order_payments op
	USING(order_id)
GROUP BY 
	YEAR(order_purchase_timestamp),
	MONTH(order_purchase_timestamp),
    WEEK(order_purchase_timestamp)
ORDER BY 
	year,month, week;

-- Average total sales by sellers
SELECT 
	oi.seller_id
    ,ROUND(SUM(op.payment_value),2) as total_sales
    ,ROUND(AVG(op.payment_value),2) as average_sales
FROM order_items oi
JOIN order_payments op
	USING(order_id)
GROUP BY seller_id;

-- for platform, total sellers number by year
-- seller number increase and revenue increase comparision 
SELECT 
	YEAR(o.order_purchase_timestamp) AS year
    ,COUNT(oi.seller_id) AS total_sellers_number
    ,ROUND(SUM(op.payment_value),2)AS total_revenue
FROM order_items oi
JOIN orders o
	USING(order_id)
JOIN order_payments op
	USING(order_id)
GROUP BY year
ORDER BY year;

-- reviwew rate
SELECT * FROM review_rate;
-- does the review rate impact the seller slaes?

SELECT 
    oi.seller_id AS seller
    ,ROUND(oi.order_item_id*(price+freight_value),2)AS total_revenue
    ,rr.review_score
FROM order_items oi
JOIN review_rate rr
	USING (order_id)
GROUP BY 
	seller,
    total_revenue,
    rr.review_score;
-- review rate score quantile
SELECT 
	AVG(review_score) AS average_review_score
FROM review_rate;

USE	Brizillian_Ecommerce;
SELECT 
    review_score AS first_quartile
FROM (
    SELECT 
        review_score,
        ROW_NUMBER() OVER (ORDER BY review_score) AS rownum,
        COUNT(*) OVER () AS total_count
    FROM 
        review_rate
) AS ranked
WHERE 
    rownum = CEIL(total_count * 0.25);
    
-- first sort the list, then calculate the quantile position(the index), and then calculate the position's value.if the position is an integer,
-- then directly go to the position and find the value. 
-- If it is not an integer,for example it is 2.5, then use (2ed+3rd)/2 get the position's value.
-- first quatile is 4, second and third quantile are 5.