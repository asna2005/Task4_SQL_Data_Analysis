-- create database
CREATE DATABASE IF NOT EXISTS retail_sales;
USE retail_sales;

-- create table
CREATE TABLE IF NOT EXISTS sales (
  transaction_id VARCHAR(10),
  sale_date DATE,
  sale_time TIME,
  customer_id VARCHAR(10),
  gender VARCHAR(10),
  age INT,
  category VARCHAR(50),
  quantity INT,
  price_per_unit DECIMAL(10,2),
  cogs DECIMAL(10,2),
  total_sale DECIMAL(10,2)
);

select*from sales;

-- import data
SELECT COUNT(*) FROM sales;

-- total number of transactions
select count(transaction_id) as total_transactions from sales;

-- total revenue
select sum(total_sale) as total_revenue from sales;

-- total revenue by product category
select category,
sum(total_sale) as category_revenue from sales
group by category
order by category_revenue desc;

-- total revenue by gender
select gender,
sum(total_sale) as gender_revenue from sales
group by gender;

-- number of sales made by each gender per category
select category,
gender,
count(transaction_id) as total_sales from sales
group by category , gender
order by category , gender;

-- total quantity sold for each category
select category,
sum(quantity) as total_quantity_sold from sales
group by category
order by total_quantity_sold desc;

-- average price per unit in each category
SELECT category,
       ROUND(AVG(price_per_unit), 2) AS avg_price
FROM sales
GROUP BY category
ORDER BY avg_price DESC;

-- total sales per month
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
       SUM(total_sale) AS monthly_revenue,
       COUNT(transaction_id) AS transactions
FROM sales
GROUP BY month
ORDER BY month;

-- top 5 customers by total amount spent
SELECT customer_id,
       SUM(total_sale) AS total_spent,
       COUNT(transaction_id) AS transactions
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- most popular product category(highest number of sales)
SELECT category,
       COUNT(transaction_id) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

-- highest single transaction value
SELECT transaction_id,
       total_sale
FROM sales
ORDER BY total_sale DESC
LIMIT 1;

-- profit for each transaction
SELECT transaction_id,
       (total_sale - cogs) AS profit
FROM sales
ORDER BY profit DESC
LIMIT 10;

-- total profit per category
SELECT category,
       SUM(total_sale - cogs) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

--  age group contribution to revenue
SELECT 
  CASE
    WHEN age < 20 THEN '<20'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50+'
  END AS age_group,
  SUM(total_sale) AS revenue
FROM sales
GROUP BY age_group
ORDER BY revenue DESC;

-- transactions that have total_sale greater than the average total_sale
SELECT *
FROM sales
WHERE total_sale > (SELECT AVG(total_sale) FROM sales)
ORDER BY total_sale DESC;

-- date with the highest revenue
SELECT sale_date,
       SUM(total_sale) AS total_revenue
FROM sales
GROUP BY sale_date
ORDER BY total_revenue DESC
LIMIT 1;

-- monthly category revenue
CREATE OR REPLACE VIEW monthly_category_revenue AS
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
       category,
       SUM(total_sale) AS revenue
FROM sales
GROUP BY month, category;
SELECT * FROM monthly_category_revenue;

-- top 3 transactions in each category
SELECT category, transaction_id, total_sale
FROM (
  SELECT category, transaction_id, total_sale,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sale DESC) AS rn
  FROM sales
) ranked
WHERE rn <= 3;

-- total items & revenue grouped by gender and category
SELECT gender,
       category,
       SUM(quantity) AS total_items,
       SUM(total_sale) AS total_revenue
FROM sales
GROUP BY gender, category
ORDER BY gender, total_revenue DESC;

    

