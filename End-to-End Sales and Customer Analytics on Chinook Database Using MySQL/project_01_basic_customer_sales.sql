-- 01_customer_analysis.sql
-- Project: End-to-End Sales and Customer Analytics on Chinook Database Using MySQL

-- Q1: How many total customers do we have?
SELECT 
    COUNT(c.CustomerId) AS total_customers
FROM
    chinook.customer c;

-- Q2: Which 5 countries have the most customers?
SELECT 
    c.Country, COUNT(c.CustomerId) AS total_customers
FROM
    chinook.customer c
GROUP BY c.Country
ORDER BY total_customers DESC
LIMIT 5;

-- Q3: Who are the top 10 customers by total revenue?
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    SUM(i.Total) AS total_revenue
FROM
    chinook.customer c
INNER JOIN
    chinook.invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY total_revenue DESC
LIMIT 10;

-- Q4: Which customers have more than 5 invoices?

-- Option 1: Using GROUP BY (preferred for performance)
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    COUNT(i.InvoiceId) AS total_invoices
FROM
    chinook.customer c
INNER JOIN
    chinook.invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING COUNT(i.InvoiceId) > 5;

-- Option 2: Using CTE and window function (shows SQL versatility)
WITH invoice_counts AS (
    SELECT 
        c.CustomerId,
        CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
        COUNT(i.InvoiceId) OVER (PARTITION BY c.CustomerId) AS total_invoices
    FROM
        chinook.customer c
    INNER JOIN
        chinook.invoice i ON c.CustomerId = i.CustomerId
)
SELECT DISTINCT Customer_Name, total_invoices
FROM invoice_counts
WHERE total_invoices > 5;

-- Q5: What is the average invoice value per customer?
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    AVG(i.Total) AS avg_invoice_value
FROM
    chinook.customer c
INNER JOIN
    chinook.invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;
