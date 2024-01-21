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

2: Customer's yearly, monthly, weekly purchasing trend, softly explore the possible reasons
There is a growth in order number and revenue from September 2016, peaking around mid-2018. However, the graph shows a drastic decline in total revenue around the same time as the drop in total orders in October 2018. The parallel decline in both orders and revenue strongly may result from the lak of data collection.
There may be patterns of peaks and troughs that could indicate seasonality in consumer purchasing behavior. Those peaks might correlate with holiday seasons or sales events. However, we lack of part of year 2016 and year 2018 data, may hard to find out the reasons behind these peaks.

3: The percentage of repeat customers, the percentag of repeat customer revenue.
<img width="538" alt="Screenshot 2024-01-14 at 1 10 42 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/1e390efe-77c0-47b8-91d2-daa9e41b0ee3">

Over 99% of the customers are one time customers, only 0.6% customers are repeat customers, and repeat customers' purchasing is weight 0.17% of total revenue.
The less repeat customers might cause serious customer loyalty issues and customer shift to competitors. The potentioal causes could be increased competition, product and service quality, and customer experience. 

4: Customer's LTV analysis: Customers' life span(retention), average order value, average order numbers. 
Average customer retention is 79.49 days, Average order value is 132.81, Average order numbers is round 2 orders

LTV(lifetime_value) = Average Transaction Size x Number of Transactions x Retention Period

Lifetime Value = 79.49x132.81x2 = 79.49x0.36x2 = 57.84, meaning the average customer is expected to bring in a value of $57.82 over the course of their relationship with the company.
#however, since the data we have is limit, the average life span needs more data to ensure.


5: Seller LTV analysis: Seller life span, average order value, average order number 

Seller LTV = (62.41 / 365) x 2281.56 x 13.27 = 5176.83, meaning the average seller is expected to bring in a value of $5176.83 over the course of their relationship with the company.

6: Which products sales better(order number and sales revenue)

<img width="833" alt="Screenshot 2024-01-14 at 1 10 04 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/e5a514fc-d993-41b6-8bb0-86b295719263">

Frome the bar graph, the top 10 prodcut categories by total revenue are Bed bath table, Health beauty, Computer accessories, Furniture decor, watches gifts, sports leisure, housewares, auto, garden tools, cool stuff and office furniture. Therefore, as a seller, if the conditions allowed, these categories can be considered first.

7: Order cancellation rate
The cancellation rate is only 0.63%, which means that approximately 1 out of 100 orders will be canceled. If the cancellation rate too high will impact the sellers performance and customers purchasing experience.

8: Review score (lower bound, average, higher bound)

The average review score is 4.07, and the lower bond (0.25) of the review score is 4, and the higher bond (0.75) of the review score is 5. As a seller, they can check which level are they. And if the review score of a seller is lower than the average, they should do something to improve their service and product quality. On the opposite, is a seller has a high review score, they should keep their score and their service and product qualities to attracting more customers.

9: Does the reiview impact the seller? Correlation analysis

<img width="713" alt="Screenshot 2024-01-14 at 1 10 59 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/54e97a84-7952-42a8-b3f6-0f705380a58c">

The correlation and coefficient of review score and sellers sales revenue is -0.035103, which means the reivew score has a relatively weak impact to sales revenue.


10: Average total sales by seller

<img width="631" alt="Screenshot 2024-01-17 at 8 00 08 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/283e2a22-eae5-4766-81ac-d32c2b39047b">

The average sales is around $231.33.From the kde plot, we found that the sales distribution among sellers are seriously left skew.


11: Seller number and revenue yearly change:

<img width="900" alt="Screenshot 2024-01-14 at 1 09 25 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/0f20b204-a3d3-4124-adfc-71256b92a370">
we can understand from the seller revenue efficiency graph. Although the seller increasing, each sellers' revenue is decreasing. We need more data to dig the reasons behind this issue. 

12: Which marketing way attracts what percentage marketing leads

<img width="817" alt="Screenshot 2024-01-17 at 8 44 20 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/396efb74-92f2-47b3-9980-64bbd5b02c68">

Marketing qualified leads are mostly attracted from organic search 28.7%,paid search is 19.83%, social is 16.88% and unknown part is 13.74.

Organic search results are the unpaid results that appear on a search engine results page after a query. Therefore, Olist should try to improve the search rank by paying more attention on search intent key words. Also, 16.88% MQL are attracted by social, they can optimize social media webpage and to further improve the search rank.  

13: The conversion rate that marketing lead become a seller
(The same seller might from differen landing pages and having different mql_id. so the conversion rate should be higher)

<img width="817" alt="Screenshot 2024-01-17 at 8 44 20 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/9f621508-1e59-468f-99a0-e8ae4ddf7b32">
The unkonw part and nan part has 16.29 and 23.33 percentage covnersion rate. so we should collect more information about that part to figure out what are the factors making the conversion rate. Beyond these two unknown parts, paid search has highest conversion rate which is 12.30 percentage. And the organic search and direct_traffic has around 11.20 percentage. The e-commerce industry benchmark conversion rate from a marketing qualified lead becomes a seller qualified is 13%. Therefore, Olist is almost reaching to the industry benchmark.
-- Focusing on the specific tunnels performance, what kind of improvements that we can do? 


14: Marketing leads attracted number yearly and monthly trends

<img width="726" alt="Screenshot 2024-01-20 at 10 41 00 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/36a0f8d2-ef41-425d-ae89-403632f66bfe">

Combine the above marketing leads attracted graphs with the monthly total order and revenu graphs, aaccompanied the peak season of sales finshed by DEc 2017, the marketing leads attracted number drastically increased from 200 to 1141.


