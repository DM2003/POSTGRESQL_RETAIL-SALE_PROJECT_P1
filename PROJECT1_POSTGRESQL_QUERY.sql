DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,	
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit FLOAT,	
cogs	FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales LIMIT 50;

-- Checking for null values
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- Since it's a small percentage, we might as well delete it
DELETE FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- Data Exploration
-- Total no of sales
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- Total amount of sales
SELECT SUM(total_sale) AS total_revenue FROM retail_sales;

-- Total no of distinct customers
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- Total no of unique categories
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- Checking the category names
SELECT DISTINCT category FROM retail_sales; 

-- SQL query to retrieve all columns for sales made on 2022-11-05
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05' ;

-- SQL query to retrieve all transactions where the category is "clothing" and the quantity sold is >3 in the month of Nov 2022
SELECT 
*
FROM retail_sales
WHERE 
category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy > 3;

-- SQL query to calculate total sales amount ad total no of sales for each category
SELECT category, SUM(total_sale), COUNT(*) AS total_no_of_sales FROM retail_sales GROUP BY category;

-- SQL query to find the average age of customers who purchased items from the beauty category
SELECT AVG(age) FROM retail_sales WHERE category = 'Beauty';

-- Group by category in the above question
SELECT category, AVG(age) FROM retail_sales AS avg_age_data GROUP BY category;

-- Find all transactions where total_sale is greater than 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- SQL query to find total no of transactions made by each gender in each category
SELECT gender, category, COUNT(*) FROM retail_sales GROUP BY gender, category;

-- SQL query to find out avg sale for each month. Find out best selling month in each year. This is where we need to use extract function
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) as total_sales_generated
FROM retail_sales
GROUP BY 1,2 -- ie: group by year and month
ORDER BY 1,3 DESC;  -- ie: order by year and avg_sales in descending order

-- Find top 10 customers based on highest total sales
SELECT customer_id, SUM(total_sale) FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 10;

-- Find no of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS customers FROM retail_sales GROUP BY category;

-- SQL query to find out the hour and minute in which we are doing this project right now (It is 12:49 pm)
SELECT EXTRACT(HOUR FROM CURRENT_TIME); -- Output: 12
SELECT EXTRACT (MINUTE FROM CURRENT_TIME); -- Output: 49

-- SQL query to create each shift and sale in that respective shift (Ex: Morning time is <= 12, Afternoon time is between 12 and 17, Evening time is >17)
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
ELSE 'Evening'
END AS shift_time
FROM retail_sales

-- Grouping everything in the previous query in a common table (let's name it hourly_sale)
WITH hourly_sale
AS
(
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
ELSE 'Evening'
END AS shift_time
FROM retail_sales
)
SELECT shift_time, SUM (total_sale) AS total_revenue FROM hourly_sale GROUP BY shift_time ;

-- End of first project