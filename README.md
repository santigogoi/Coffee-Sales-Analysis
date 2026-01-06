# 🍵Coffee-Sales-Analysis

## Objective
The goal of this project is to analyse the sales data of Coffee Shop, the shop that has been selling its products online since January 2023, and to recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

## Tech Stack
The project was built using the following tools and technologies:<br>

• MySQL Workbench

## Data Source
Source: Zero Analyst 

Data on multiple tables ~10,000 rows, consists of coffee sales transactions, customer information, and product details.

## Key Questions
1. **Coffee Consumers Count**  
   How many people in each city are estimated to consume coffee, given that 25% of the population does?

2. **Total Revenue from Coffee Sales**  
   What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

3. **Sales Count for Each Product**  
   How many units of each coffee product have been sold?

4. **Average Sales Amount per City**  
   What is the average sales amount per customer in each city?

5. **City Population and Coffee Consumers**  
   Provide a list of cities along with their populations and estimated coffee consumers.

6. **Top Selling Products by City**  
   What are the top 3 selling products in each city based on sales volume?

7. **Customer Segmentation by City**  
   How many unique customers are there in each city who have purchased coffee products?

8. **Average Sale vs Rent**  
   Find each city and their average sale per customer and average rent per customer

9. **Monthly Sales Growth**  
   Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

10. **Market Potential Analysis**  
    Identify the top 3 cities based on the highest sales, return city name, total sales, total rent, total customers, and  estimated  coffee consumers
    
## Findings
1. **Delhi** has the highest coffee consumer base **(7.75 million)**, but it does not generate the highest revenue.

2. **Pune** is the top revenue-generating city **(₹434,330)** despite having a moderate consumer base.

3. **Pune** records the highest average sales per customer **(₹24,197.88)**, indicating strong customer spending behaviour.

4. **Chennai** and **Bangalore** also show high sales efficiency with average sales per customer above **₹22,000**.

5. **Mumbai**, though second in consumer population **(5.10 million)**, shows relatively low revenue **(₹71,340)**.

6. **Jaipur** has the highest number of **unique customers (69)**, showing strong customer acquisition.

7. **Cold Brew Coffee Pack** is the best-selling product with **1,326 units sold**.

8. Beverage products significantly outperform accessories in overall sales volume.

9. **Mumbai** has the highest estimated rent **(₹31,500)** but low revenue efficiency.

10. **Hyderabad** and **Bangalore** incur high rent per customer, impacting profitability.

11. Smaller cities with efficient customer conversion outperform larger metros in revenue contribution.

12. Revenue performance is driven more by average spend per customer than by total consumer population.

## Recommendations
After analysing the data, the recommended top three cities for new store openings are:

**City 1: Pune**  
1. Average rent per customer is very low at **294**.
2. The highest total revenue is **₹12,58,290**.  
3. Average sales per customer are also high **(24197.88)**.

**City 2: Delhi**  
1. The highest estimated coffee consumers is at **7.7 million**.  
2. The highest total number of customers is **68**.  
3. Average rent per customer is **330** (still under 500).

**City 3: Jaipur**  
1. The highest number of customers is **69**.  
2. Average rent per customer is very low at **156**.  
3. Average sales per customer are better at **11.6k**.
