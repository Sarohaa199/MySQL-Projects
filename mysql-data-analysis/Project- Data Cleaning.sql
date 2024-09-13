-- Data Cleaning Project

-- Load the data from the source table
SELECT * 
FROM world_layoffs.layoffs;

-- Create a staging table to work with. This preserves the original data for reference.
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

-- Insert data into the staging table
INSERT INTO world_layoffs.layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

-- Step 1: Remove Duplicates

-- Identify duplicates by comparing all columns.
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM world_layoffs.layoffs_staging;

-- View duplicates to confirm
SELECT *
FROM (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM world_layoffs.layoffs_staging
) duplicates
WHERE row_num > 1;

-- Remove duplicates by creating a new staging table with row numbers
CREATE TABLE world_layoffs.layoffs_staging_cleaned AS
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
FROM (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM world_layoffs.layoffs_staging
) duplicates
WHERE row_num = 1;

-- Drop the old staging table and rename the cleaned one
DROP TABLE world_layoffs.layoffs_staging;
RENAME TABLE world_layoffs.layoffs_staging_cleaned TO world_layoffs.layoffs_staging;

-- Step 2: Standardize Data

-- Check distinct values in the industry column for inconsistencies
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging
ORDER BY industry;

-- Handle null and empty values in the industry column
UPDATE world_layoffs.layoffs_staging
SET industry = NULL
WHERE industry = '';

-- Populate null industry values based on other rows with the same company
UPDATE world_layoffs.layoffs_staging t1
JOIN world_layoffs.layoffs_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Standardize industry names
UPDATE world_layoffs.layoffs_staging
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Standardize country names by trimming trailing periods
UPDATE world_layoffs.layoffs_staging
SET country = TRIM(TRAILING '.' FROM country);

-- Standardize date format
UPDATE world_layoffs.layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging
MODIFY COLUMN `date` DATE;

-- Step 3: Look at Null Values

-- Examine rows with null values in critical columns
SELECT *
FROM world_layoffs.layoffs_staging
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL
  AND funds_raised_millions IS NULL;

-- Step 4: Remove Unnecessary Columns and Rows

-- Remove rows where both total_laid_off and percentage_laid_off are null
DELETE FROM world_layoffs.layoffs_staging
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Drop the temporary column used for handling duplicates if it was added
ALTER TABLE world_layoffs.layoffs_staging
DROP COLUMN row_num;

-- Final check
SELECT * 
FROM world_layoffs.layoffs_staging;
