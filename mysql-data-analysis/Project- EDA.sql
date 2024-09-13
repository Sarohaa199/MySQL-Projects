-- Exploratory Data Analysis (EDA)
-- In this section, we'll analyze the data to identify key trends, patterns, and anomalies. 

-- Begin by inspecting a sample of the data to understand its structure
SELECT * 
FROM world_layoffs.layoffs_staging2
LIMIT 10;

-- Basic Queries

-- What is the maximum number of layoffs recorded in a single event?
SELECT MAX(total_laid_off) AS max_single_layoff
FROM world_layoffs.layoffs_staging2;

-- What are the highest and lowest percentages of layoffs reported?
SELECT MAX(percentage_laid_off) AS highest_percentage, MIN(percentage_laid_off) AS lowest_percentage
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Identify companies where the entire workforce (100%) was laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- Examine companies with 100% layoffs and sort by funds raised to assess their financial scale
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Intermediate Queries

-- Determine which companies had the largest single layoff event
SELECT company, total_laid_off AS largest_layoff
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

-- Find the top 10 companies with the highest total layoffs across all events
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

-- Identify the top locations with the highest total layoffs
SELECT location, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;

-- Aggregate the total layoffs by country
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;

-- Analyze layoffs by year to understand annual trends
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY year ASC;

-- Summarize layoffs by industry to see which sectors were most affected
SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;

-- Evaluate layoffs based on company stage (e.g., startup, growth) to see how different stages were impacted
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;

-- Advanced Queries

-- Determine the top companies with the highest layoffs per year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS yearly_layoffs
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, YEAR(date)
),
Ranked_Company_Year AS (
  SELECT company, year, yearly_layoffs, 
         DENSE_RANK() OVER (PARTITION BY year ORDER BY yearly_layoffs DESC) AS rank
  FROM Company_Year
)
SELECT company, year, yearly_layoffs, rank
FROM Ranked_Company_Year
WHERE rank <= 3
ORDER BY year ASC, yearly_layoffs DESC;

-- Calculate the rolling total of layoffs by month to observe trends over time
SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS monthly_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY month
ORDER BY month ASC;

-- Use a CTE to compute the cumulative (rolling) total of layoffs per month
WITH Monthly_Layoffs AS 
(
  SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS monthly_layoffs
  FROM world_layoffs.layoffs_staging2
  GROUP BY month
  ORDER BY month ASC
)
SELECT month, 
       SUM(monthly_layoffs) OVER (ORDER BY month ASC) AS cumulative_layoffs
FROM Monthly_Layoffs
ORDER BY month ASC;
