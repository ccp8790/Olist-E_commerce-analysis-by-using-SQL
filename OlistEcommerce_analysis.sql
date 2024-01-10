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
-- repeat purchase percentage = 0.6407 
SELECT 
    (SELECT COUNT(*) 
     FROM (SELECT c.customer_unique_id
           FROM customers_dataset c
           JOIN orders o ON c.customer_id = o.customer_id
           GROUP BY c.customer_unique_id
           HAVING COUNT(o.order_id) > 1) AS repeat_customers
    ) * 100.0 / COUNT(DISTINCT c.customer_unique_id) AS repeat_purchase_percentage
FROM 
    customers_dataset c;
-- !!!!!! hard to calculate the repeat purchase revenue
SELECT 
    SUM(op.payment_value) AS total_revenue_from_repeat_customers
FROM 
    (
        SELECT 
            DISTINCT o.order_id
        FROM 
            orders o
        INNER JOIN 
            customers_dataset c ON o.customer_id = c.customer_id
        WHERE 
            c.customer_unique_id IN (
                SELECT 
                    c.customer_unique_id
                FROM 
                    customers_dataset c
                INNER JOIN 
                    orders o ON c.customer_id = o.customer_id
                GROUP BY 
                    c.customer_unique_id
                HAVING 
                    COUNT(DISTINCT o.order_id) > 1
            )
    ) AS repeat_orders
JOIN 
    order_payments op ON repeat_orders.order_id = op.order_id;

    
    
    
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
CREATE TABLE repeate_customer_analysis AS
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
    
SELECT 
    ROUND(AVG(days_between_first_and_last_order),2)AS avg_days_between_orders,
    ROUND(AVG(average_order_value),2)AS avg_order_value,
    ROUND(AVG(total_orders),2)AS avg_total_orders
FROM 
    repeate_customer_analysis;
--  average customer retention is 79.49 days
--  average order value is 132.81
--  average order numbers is round 2 orders
-- LTV(lifetime_value) = Average Transaction Size x Number of Transactions x Retention Period
-- lifetime_value = 79.49*132.81*2 = 0.217*132.81*2 = 57.82
-- CLV(customer_lifetime_value) = LTV *profit_margin
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

-- Clean the dataset 
SELECT * 
FROM closed_deals;

SELECT
    (SUM(CASE WHEN mql_id = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS mql_id_null_percentage,
    (SUM(CASE WHEN seller_id = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS seller_id_null_percentage,
    (SUM(CASE WHEN sdr_id = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS sdr_id_null_percentage,
	(SUM(CASE WHEN sr_id = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS sr_id_null_percentage,
    (SUM(CASE WHEN won_date = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS won_date_null_percentage,
    (SUM(CASE WHEN business_segment = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS business_segment_null_percentage,
    (SUM(CASE WHEN lead_type = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS lead_type_null_percentage,
    (SUM(CASE WHEN lead_behaviour_profile = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS lead_behaviour_profile_null_percentage,
    (SUM(CASE WHEN has_company = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS has_company_null_percentage,
	(SUM(CASE WHEN has_gtin = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS has_gtin_null_percentage,
    (SUM(CASE WHEN average_stock = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS average_stock_null_percentage,
    (SUM(CASE WHEN business_type = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS business_type_null_percentage,
	(SUM(CASE WHEN declared_product_catalog_size = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS declared_product_catalog_size_null_percentage,
    (SUM(CASE WHEN declared_monthly_revenue = '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS declared_monthly_revenue_null_percentage
FROM
    closed_deals;
-- Based on the result, we will drop the columns that contains null value more than 90

START TRANSACTION;

CREATE TABLE backup_closed_deals AS SELECT * FROM closed_deals;


ALTER TABLE closed_deals DROP COLUMN has_company;
ALTER TABLE closed_deals DROP COLUMN has_gtin;
ALTER TABLE closed_deals DROP COLUMN declared_product_catalog_size;
ALTER TABLE closed_deals DROP COLUMN average_stock;
ALTER TABLE closed_deals DROP COLUMN declared_monthly_revenue;
ALTER TABLE closed_deals DROP COLUMN MyUnknownColumn;
COMMIT;

SELECT*
FROM closed_deals;

SELECT *
FROM marketing_qualified_leads;

-- LTV analysis of seller(marketing leads)  
CREATE TABLE merged_table AS 
SELECT 
	cd.mql_id,
    cd.seller_id,
    cd.sr_id,
    cd.won_date,
    m.first_contact_date,
    cd.business_segment,
    cd.lead_type,
    cd.business_type,
    cd.lead_behaviour_profile,
    m.landing_page_id,
    m.origin
FROM closed_deals cd
JOIN marketing_qualified_leads m
	USING(mql_id);
    
SELECT * FROM merged_table;

CREATE TABLE seller_analysis AS 
SELECT 
	mt.seller_id AS seller,
    COUNT(oi.order_id) AS order_numbers,
    DATEDIFF(MAX(oi.shipping_limit_date), MIN(oi.shipping_limit_date) )AS shipping_date_range,
    ROUND(SUM((oi.price+oi.freight_value)*oi.order_item_id),2)AS order_value
FROM merged_table mt
JOIN order_items oi
	USING(seller_id)
GROUP BY seller;


SELECT 
    ROUND(AVG(shipping_date_range),2)AS avg_lifetime,
    ROUND(AVG(order_value),2)AS avg_order_value,
    ROUND(AVG(order_numbers),2)AS avg_orders_numbers
FROM 
    seller_analysis;
    
-- LTV = (62.41/365)*2281.56 *13.27 = 5176.83


-- marketing funnel anlysis
-- which way atrracts what percentage of marteking lead
-- and how many marketing lead are finally transfer to seller, the conversion rate of different channel 
-- the same seller might from differen landing pages and having different mql_id. so the conversion rate should be higher
-- the first contact date can show the trend of the platform attracting the sellers. group by minth and line graph


-- the first attracting growing trend:
SELECT 
	YEAR(first_contact_date) AS year,
	MONTH(first_contact_date) AS month,
	COUNT(mql_id) AS count_of_ids
FROM marketing_qualified_leads
GROUP BY
	year,month
ORDER BY
	year,month;
    
    
    
-- where are these mql from? 
CREATE TABLE mql_tunnels AS
SELECT
	origin AS tunnels,
	COUNT(mql_id) AS count_of_ids,
    COUNT(mql_id) / (SELECT COUNT(mql_id) FROM marketing_qualified_leads) * 100 AS percentage
FROM marketing_qualified_leads
GROUP BY tunnels
ORDER BY count_of_ids DESC; 
-- most populor tunnel is organic_search. and there are 25% empty cells and 13.7% unknown data 

-- where are these sellers from?

CREATE TABLE seller_tunnels AS
SELECT
	mql.origin AS tunnels,
	COUNT(cd.mql_id) AS count_of_ids
    ,ROUND(COUNT(cd.mql_id)/ 842 * 100, 2) AS percentage
FROM closed_deals cd
JOIN  marketing_qualified_leads mql ON cd.mql_id = mql.mql_id
GROUP BY tunnels
ORDER BY count_of_ids DESC;
-- organic_search tunnel has 32.19% , and paid search has 23.26 

-- Calculate different tunnels conversion rate

SELECT 
    st.tunnels AS tunnels,
    st.count_of_ids AS seller_numbers,
    mt.count_of_ids AS mql_numbers,
    ROUND((st.count_of_ids / mt.count_of_ids) * 100, 2) AS conversion_rate
FROM 
    seller_tunnels st
JOIN 
    mql_tunnels mt ON mt.tunnels = st.tunnels;

-- unkonw part and empty part has 16.29 and 23.33 percentage covnersion rate. so we should collect more information about that part.
-- beyond these two tunnels, paid search has highest conversion rate which is 12.30 percentage. And the organic search and direct_traffic has around 11.20 percentage.
-- what is our competitors conversion rate? what is the conversion rate baseline for E-commerce of these tunnels
-- Focusing on the specific tunnels performance, what kind of improvements that we can do? 
    