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

1: What are the annual figures for customers, orders, sales, and sellers, along with the year-over-year changes?

### Customer analysis:

2: Analyze the annual, monthly, and weekly purchasing trends of customers, and explore the potential factors contributing to these trends.

3: Examine the percentage of repeat customers and the percentage of repeat customer revenue.

4: Conduct a Customer Lifetime Value (LTV) analysis, including customer retention rates, average order values, and average order numbers.

### Seller might concern:

5: Perform a Seller Lifetime Value (LTV) analysis, considering seller lifespan, average order values, and average order numbers.

6: Identify which products have higher sales in terms of order numbers and sales revenue.

7: Calculate the order cancellation rate.

8: Evaluate review scores, including lower bounds, averages, and higher bounds, and assess their impact on sellers through correlation analysis.

9: Investigate the impact of reviews on sellers through correlation analysis.

10: Determine the average total sales per seller.

11: Examine the yearly changes in the number of sellers and their revenues, and conduct an efficiency analysis based on revenue per seller. Compare these results with the industry average to understand competitive performance.

### Marketing funnel analysis
	
12: Analyze which marketing strategies attract what percentage of marketing leads.

13: Calculate the conversion rate of marketing leads becoming sellers, considering that the same seller may come from different landing pages and have different MQL_IDs, potentially resulting in a higher conversion rate.

14: Track yearly and monthly trends in seller acquisition.


## Optimize Mysql server performance

Step 1: Manage Mysql bufferpool size (128m to 512m)

Step 2: Split and extract the key variables from the original big table into new samll table for easily analysis

Step 3: Add index for mainly using table and columns

Step 4: Optimize Mysql query

Step 5: Change the TEXT data type to VARCHAR(255) data type for quickly analysis

Step 6: Limit rows for each query





### Visualization and Analysis

1: What are the annual figures for customers, orders, sales, and sellers, along with the year-over-year changes?

In year 2016, the seller number is 385, the total revenue is 74281.72, and the total order is 346; In year 2017, the seller number is 53539, the total revenue is 7249746.73, and the total order is 47525;

<img width="909" alt="Screenshot 2024-01-14 at 1 08 54 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/64db0ba1-0078-44bb-b5f3-ce29961918a9">

Between 2016 and 2018, the overall revenue, seller count, and order numbers consistently witnessed growth. However, it is notable that the rate of increase from 2017 to 2018 slowed compared to the growth observed from 2016 to 2017. Several factors could contribute to this slowdown, including heightened competition from external players, potentially reaching a plateau phase, and a potential decrease in the appeal of the platform's services compared to previous years.

2: Analyze the annual, monthly, and weekly purchasing trends of customers, and explore the potential factors contributing to these trends.

There is a growth in the number of orders and revenue from September 2016, reaching a peak around mid-2018. However, the graph depicts a significant decline in total revenue, coinciding with a drop in total orders in October 2018. This simultaneous decline in both orders and revenue may be attributed to a potential lack of data collection during that period.
There appear to be patterns of peaks and troughs that could suggest seasonality in consumer purchasing behavior, possibly correlated with holiday seasons or sales events. However, due to the absence of data for parts of 2016 and 2018, it may be challenging to ascertain the exact reasons behind these peaks..

3: Examine the percentage of repeat customers and the percentage of repeat customer revenue.

<img width="538" alt="Screenshot 2024-01-14 at 1 10 42 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/1e390efe-77c0-47b8-91d2-daa9e41b0ee3">

More than 99% of our customers are one-time purchasers, with only 0.6% being repeat customers. The repeat customers' contributions to our total revenue are modest, accounting for just 0.17%.
The limited presence of repeat customers raises concerns about customer loyalty and the potential migration of customers to competitors. Possible contributing factors to this trend include heightened competition, product and service quality, and overall customer experience

4: Conduct a Customer Lifetime Value (LTV) analysis, including customer retention rates, average order values, and average order numbers. 

The average customer retention period is 79.49 days, with an average order value of $132.81 and an average of approximately 2 orders per customer.
To calculate the Lifetime Value (LTV), we can use the formula:

LTV (Lifetime Value) = Average Transaction Size x Number of Transactions x Retention Period

So, LTV = 79.49 days x $132.81 x 2 orders = $79.49 x 0.36 x 2 = $57.84. This means that, on average, each customer is expected to generate a value of $57.84 during their relationship with the company.
However, it's important to note that the accuracy of this average lifespan calculation may be affected by the limited data available, and more data would be needed to ensure its reliability.

5: Perform a Seller Lifetime Value (LTV) analysis, considering seller lifespan, average order values, and average order numbers. 

Seller Lifetime Value (LTV) is calculated as follows:
LTV = (Average Daily Earnings ($62.41) / 365 days) x Total Seller Lifespan (13.27 years) x Total Earnings ($2281.56)
LTV = ($0.1711 per day) x 13.27 years x $2281.56 = $5176.83
This calculation suggests that, on average, each seller is expected to generate a value of $5176.83 over the course of their partnership with the company.

6: Identify which products have higher sales in terms of order numbers and sales revenue.

<img width="833" alt="Screenshot 2024-01-14 at 1 10 04 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/e5a514fc-d993-41b6-8bb0-86b295719263">

Based on the information presented in the bar graph, the top 10 product categories ranked by total revenue are as follows: Bed bath table, Health beauty, Computer accessories, Furniture decor, Watches gifts, Sports leisure, Housewares, Auto, Garden tools, Cool stuff, and Office furniture. Therefore, if circumstances permit, sellers may want to prioritize these categories when making product selections.

7: Calculate the order cancellation rate.
The cancellation rate is a mere 0.63%, indicating that roughly 1 out of every 100 orders may be subject to cancellation. It's important to note that a high cancellation rate can have adverse effects on both seller performance and the overall customer purchasing experience.

8: Evaluate review scores, including lower bounds, averages, and higher bounds, and assess their impact on sellers through correlation analysis.

The average review score stands at 4.07, with the lower quartile (25th percentile) review score being 4 and the upper quartile (75th percentile) review score being 5. Sellers can use this information to assess their performance levels. 
If a seller's review score falls below the average, it may be advisable for them to take proactive measures to enhance their service and product quality. Conversely, if a seller boasts a high review score, it's crucial for them to maintain their excellent rating by consistently delivering exceptional service and product quality to continue attracting more customers.

9: Investigate the impact of reviews on sellers through correlation analysis.

<img width="713" alt="Screenshot 2024-01-14 at 1 10 59 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/54e97a84-7952-42a8-b3f6-0f705380a58c">

The correlation coefficient between the review score and sellers' sales revenue is -0.035103. This indicates that there is a relatively weak correlation between review scores and sales revenue, suggesting that changes in review scores have a limited impact on sales revenue.


10: Determine the average total sales per seller.

<img width="631" alt="Screenshot 2024-01-17 at 8 00 08 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/283e2a22-eae5-4766-81ac-d32c2b39047b">

The average sales amount is approximately $231.33. Based on the kernel density estimation (KDE) plot, it is evident that the distribution of sales among sellers exhibits a significant left skew, indicating that a majority of sellers have lower sales values compared to the average.

11: Examine the yearly changes in the number of sellers and their revenues, and conduct an efficiency analysis based on revenue per seller. Compare these results with the industry average to understand competitive performance.

<img width="900" alt="Screenshot 2024-01-14 at 1 09 25 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/0f20b204-a3d3-4124-adfc-71256b92a370">
From the seller revenue efficiency graph, it becomes apparent that despite an increase in the number of sellers, the revenue generated by each individual seller is declining.

12: Analyze which marketing strategies attract what percentage of marketing leads.

<img width="817" alt="Screenshot 2024-01-17 at 8 44 20 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/396efb74-92f2-47b3-9980-64bbd5b02c68">

Marketing qualified leads are primarily sourced from organic search (28.7%), followed by paid search (19.83%), with social media accounting for 16.88%. A portion (13.74%) of leads comes from an unknown source.

Organic search refers to unpaid results that appear on a search engine results page after a query. Therefore, Olist should focus on enhancing its search ranking by prioritizing search intent keywords. Additionally, given that 16.88% of MQLs are attracted through social media, optimizing social media webpages can further contribute to improving search rankings and attracting more leads.

13: Calculate the conversion rate of marketing leads becoming sellers, considering that the same seller may come from different landing pages and have different MQL_IDs, potentially resulting in a higher conversion rate.

<img width="817" alt="Screenshot 2024-01-17 at 8 44 20 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/9f621508-1e59-468f-99a0-e8ae4ddf7b32">
The unknown (unknown part) and NaN (unavailable data) segments exhibit a conversion rate of 16.29% and 23.33%, respectively. This indicates the importance of gathering more information about these segments to identify the factors influencing their conversion rates.

Among the known sources, paid search boasts the highest conversion rate at 12.30%, while organic search and direct traffic yield approximately 11.20%. It's worth noting that the e-commerce industry benchmark for conversion rates from marketing qualified leads to seller qualified leads stands at 13%. Remarkably, Olist is approaching this industry benchmark, showcasing its effectiveness in this regard.

What kind of improvements for marketing strategies that we can do? 
- 
- Paid Reasearch: refine and expand the list of target keywords, focus on high-intent keywords taht are likely to convert. improve cick-through rates and conversion rates by refining ad copy, targeting and bidding strategies. Ensure that landing pages are highly relevant to the ad content, user-friendly, and optimized for conversions.

- Organic Search: develop high-quality, relevant, and informative content that addresses the needs and interests of target sudiences. Invest in search engine optimization (SEO) to improve organic search rankings.

- Social Media: Enhance the social media content by creating engaging and sharable content that resonates with the target audience. Consider running targeted social media advertising compaigns to reach a wider audience and drive more qualified leads.

- General improvement by A/B testing to evaluate different strategies, messaging, and designs to determine what works best of each source.

14: Track yearly and monthly trends in seller acquisition.

<img width="726" alt="Screenshot 2024-01-20 at 10 41 00 PM" src="https://github.com/ccp8790/Olist-E_commerce-analysis-by-using-SQL/assets/119828359/36a0f8d2-ef41-425d-ae89-403632f66bfe">

Integrate the marketing leads attracted graphs presented above with the monthly total order and revenue graphs. Notably, during the peak sales season ending in December 2017, there was a significant surge in the number of marketing leads attracted, surging from 200 to 1141. This correlation underscores the importance of examining the interplay between marketing efforts and sales performance.

