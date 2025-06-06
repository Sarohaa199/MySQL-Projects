-- Q1. What is the total revenue generated each month?
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month_Year,
    SUM(Total) AS total_revenue
FROM invoice
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY DATE_FORMAT(InvoiceDate, '%Y-%m');

-- Q2. What are the top 3 billing countries by total sales?
SELECT 
    BillingCountry, 
    SUM(Total) AS total_revenue
FROM invoice
GROUP BY BillingCountry
ORDER BY total_revenue DESC
LIMIT 3;

-- Q3. Which employee (sales support agent) has generated the most revenue?
SELECT
    CONCAT(em.FirstName, ' ', em.LastName) AS Employee_Name,
    SUM(ic.Total) AS Total_Revenue
FROM
    employee em
    INNER JOIN customer cu ON em.EmployeeId = cu.SupportRepId
    INNER JOIN invoice ic ON ic.CustomerId = cu.CustomerId
GROUP BY em.EmployeeId, em.FirstName, em.LastName
ORDER BY Total_Revenue DESC
LIMIT 1;
    
-- Q4. What is the average invoice total per month?
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month_Year,
    AVG(Total) AS Average_Month
FROM
    invoice
GROUP BY Month_Year
ORDER BY Month_Year;

-- Q5. What is the revenue trend over time?
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month_Year,
    SUM(Total) AS Total_Per_Month
FROM
    invoice
GROUP BY Month_Year
ORDER BY Month_Year;