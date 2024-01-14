# Olist-E_commerce-analysis-by-using-SQL
## About Olist
Olist is a Brazilian e-commerce company founded in 2014. It operates an online marketplace aggregation platform intended to facilitate direct sales on various e-commerce sites. The platform connects small businesses from all over Brazil to larger market channels without the hassle and with a single contract. These merchants can sell their products through the Olist Store and ship them directly to customers using Olist's logistics partners.

As for the company's development trend, Olist has shown significant growth over the years, marked by multiple funding rounds that indicate investor confidence. For instance, it secured $186 million in a Series E funding round, reaching a valuation of $1.5 billion as of December 2021. This suggests a strong upward trajectory, positioning Olist as a notable player in the e-commerce platform space in Brazil. The company's growth has been fueled by the e-commerce boom, especially during the pandemic, and its ability to empower merchants with its platform.

## Database
This is a Brazilian ecommerce public dataset of orders made at Olist E-commerce Company. The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews scores rated by customers. Also for Olist company released sellers marketing funnel data because sellers are also important part of their customers.

Database schema
<img width="1156" alt="Screenshot 2024-01-12 at 8 55 59 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/e02d17a8-3324-4ac8-8a19-398ebe945e53">


Datasets can be found in below link

For order,patments,product, review, customers datasets:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data. 

For marketing funnel data:
https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist/data.

This image shows how different dataset has been organized and related.

![image](https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/2dffb08f-ab7c-4034-8958-606b7a75b374)

## Objectives
In the repository, some descriptive analyses are explored. Also the sales pattern, sales trend and customers analysis are uncovered. The audience of these analysis are mainly sellers, olist company employees.

Extract data information and explore the datasets by using MySQL.
Analyze the datasets to answer following questions:

1: How many customers, orders, sales, sellers yearly? and year over year change

### Customer analysis:

2: Customer's yearly, monthly, weekly purchasing trend, softly explore the possible reasons

3: The percentage of repeat customers, the percentag of repeat customer revenue

4: Customer's LTV analysis: Customers' life span(retention), average order value, average order numbers. 

### Seller might concern:

5: Seller LTV analysis: Seller life span, average order value, average order number 

6: Which products sales better(order number and sales revenue)

7: Order cancellation rate

8: Review score (lower bound, average, higher bound)

9: Does the reiview impact the seller? Correlation analysis

10: Average total sales by seller

11: Seller number and revenue yearly change (can analysis ):

    - Efficency analysis: revenue per seller
    - CAGR
    - Compare with the industry average to understand the competitive performance

### Marketing funnel analysis
	
12: Which marketing way attracts what percentage marketing leads

13: The conversion rate that marketing lead become a seller
(The same seller might from differen landing pages and having different mql_id. so the conversion rate should be higher)

14: Seller attracting yearly and monthly trends


## Optimize Mysql server performance

Step 1: Manage Mysql bufferpool size (128m to 512m)

Step 2: Split and extract the key variables from the original big table into new samll table for easily analysis

Step 3: Add index for mainly using table and columns

Step 4: Optimize Mysql query

Step 5: Change the TEXT data type to VARCHAR(255) data type for quickly analysis

Step 6: Limit rows for each query





### Visualization and Analysis

1: How many customers, orders, sales, sellers yearly? and year over year change:
In year 2016, the seller number is 385, the total revenue is 74281.72, and the total order is 346; In year 2017, the seller number is 53539, the total revenue is 7249746.73, and the total order is 47525;

<img width="909" alt="Screenshot 2024-01-14 at 1 08 54 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/64db0ba1-0078-44bb-b5f3-ce29961918a9">

From 2016 to 2018, the total revenue, total seller number, and total order numbers are keep increasing, but the increasing speed from 2017 to 2018 is getting lower than 2016 to 2017.
There are few possible reasons: the outside competitors, getting to the plateau period, and the platform service is not attracting than before.

<img width="900" alt="Screenshot 2024-01-14 at 1 09 25 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/0f20b204-a3d3-4124-adfc-71256b92a370">
we can understand from the seller revenue efficiency graph. ALthough the seller increasing, each sellers' revenue is decreasing. We need more data to dig the reasons behind this issue. 

2: Customer's yearly, monthly, weekly purchasing trend, softly explore the possible reasons
There is a growth in order number and revenue from September 2016, peaking around mid-2018. However, the graph shows a drastic decline in total revenue around the same time as the drop in total orders in October 2018. The parallel decline in both orders and revenue strongly may result from the lak of data collection.
There may be patterns of peaks and troughs that could indicate seasonality in consumer purchasing behavior. Those peaks might correlate with holiday seasons or sales events. However, we lack of part of year 2016 and year 2018 data, may hard to find out the reasons behind these peaks.

3: The percentage of repeat customers, the percentag of repeat customer revenue.
<img width="538" alt="Screenshot 2024-01-14 at 1 10 42 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/1e390efe-77c0-47b8-91d2-daa9e41b0ee3">
over 99% of the customers are one time customers, only 0.6% customers are repeat customers, and repeat customers' purchasing is weight 0.17% of total revenue.


4: Customer's LTV analysis: Customers' life span(retention), average order value, average order numbers. 

