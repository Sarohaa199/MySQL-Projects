-- Let's dive into the basics of SELECT statements in SQL.

-- To get everything from a table, you use the asterisk (*). It’s a quick way to pull all columns.
SELECT * 
FROM parks_and_recreation.employee_demographics;

-- If you only need specific columns, list them explicitly:
SELECT first_name
FROM employee_demographics;

-- You can add more columns by separating them with commas:
SELECT first_name, last_name
FROM employee_demographics;

-- Column order doesn’t usually matter, but sometimes it can, so keep an eye on that:
SELECT last_name, first_name, gender, age
FROM employee_demographics;

-- For readability, especially with lots of columns, you can format your query like this:
SELECT last_name, 
       first_name, 
       gender, 
       age
FROM employee_demographics;

-- You can also do calculations directly in your SELECT statement:
SELECT first_name,
       last_name,
       total_money_spent,
       total_money_spent + 100 AS adjusted_spent  -- Adding 100 to total_money_spent
FROM customers;

-- Remember, SQL uses PEMDAS for calculations: Parentheses, Exponents, Multiplication, Division, Addition, Subtraction.

-- Example of simple math:
SELECT first_name, 
       last_name,
       salary,
       salary + 100 AS new_salary  -- Just adding 100 to the salary
FROM employee_salary;

-- If you use parentheses, SQL will do the operations inside first:
SELECT first_name, 
       last_name,
       salary,
       (salary + 100) * 10 AS scaled_salary  -- Adds 100 to the salary and multiplies by 10
FROM employee_salary;

-- Want to get rid of duplicates? Use DISTINCT:
SELECT department_id
FROM employee_salary;

-- DISTINCT filters out duplicate department IDs, giving you only unique values:
SELECT DISTINCT department_id
FROM employee_salary;

# WHERE Clause:
# -------------
# The WHERE clause filters rows based on a condition.
# It helps you pull out only the rows that meet the criteria you specify.

-- For example, to get all records where the salary is greater than 50,000:
SELECT *
FROM employee_salary
WHERE salary > 50000;

-- If you want to include salaries that are exactly 50,000, use >=:
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- To filter by gender:
SELECT *
FROM employee_demographics
WHERE gender = 'Female';

-- To get rows where gender is not Female:
SELECT *
FROM employee_demographics
WHERE gender != 'Female';

-- Filtering by date is straightforward as well:
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';

-- Note: 'YYYY-MM-DD' is the standard date format in MySQL, but there are others too.

# LIKE Statement:
# ----------------
# The LIKE statement is handy for pattern matching in strings.
# It uses special characters like % and _.

-- % matches any sequence of characters:
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a%';  -- Finds names starting with 'a'

-- _ matches a single character:
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__';  -- Finds names starting with 'a' followed by exactly two characters

-- You can combine % and _ for more flexible patterns:
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%';  -- Finds names starting with 'a' followed by at least three characters

-- Group By
-- -------------
-- GROUP BY is used to group rows that have the same values in specified columns.
-- This is particularly useful when you want to perform aggregate functions like COUNT, AVG, SUM, etc., on each group.

-- Here's the basic usage:
SELECT *
FROM employee_demographics;

-- To group by a single column (e.g., gender), use:
SELECT gender
FROM employee_demographics
GROUP BY gender;

-- Note: You need to include the column(s) you're grouping by in the SELECT statement, but you can't select columns that aren't included in the GROUP BY or in aggregate functions.

-- This won't work because `first_name` isn't in GROUP BY or an aggregate function:
SELECT first_name
FROM employee_demographics
GROUP BY gender;

-- Correct usage:
SELECT occupation
FROM employee_salary
GROUP BY occupation;

-- Grouping by multiple columns (e.g., occupation and salary) will give you a row for each unique combination of those columns:
SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

-- Aggregate functions with GROUP BY are very useful:
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;

-- You can use multiple aggregate functions to get different stats for each group:
SELECT gender, MIN(age) AS min_age, MAX(age) AS max_age, COUNT(age) AS count_age, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;

# ORDER BY Clause
# -------------------
# ORDER BY is used to sort the results of your query either in ascending or descending order.

-- By default, ORDER BY sorts results in ascending order. Use DESC for descending order.

-- Simple sorting by one column (e.g., first_name):
SELECT *
FROM customers
ORDER BY first_name;

-- To sort in descending order:
SELECT *
FROM employee_demographics
ORDER BY first_name DESC;

-- You can also sort by multiple columns. For example, sort by gender and then age:
SELECT *
FROM employee_demographics
ORDER BY gender, age;

-- To sort both columns in descending order:
SELECT *
FROM employee_demographics
ORDER BY gender DESC, age DESC;

-- You can sort by column position instead of column names, though it's less clear:
SELECT *
FROM employee_demographics
ORDER BY 5 DESC, 4 DESC;  -- 5 is the position of the first column and 4 of the second column

-- It's generally best to use column names for clarity and to avoid issues if the table structure changes.

-- That's a basic overview of using ORDER BY. It's a powerful tool for organizing query results.

-- HAVING vs WHERE
-- ---------------
-- Both `HAVING` and `WHERE` are used to filter rows, but they serve different purposes.
-- 
-- WHERE filters rows before any grouping or aggregation takes place.
-- HAVING filters rows after the data has been grouped and aggregated.

-- Example: Calculate the average age by gender
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;

-- Trying to filter based on aggregated data with WHERE (this won't work):
SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender;

-- Explanation: WHERE cannot be used for filtering on aggregated data because it operates before the GROUP BY. 
-- To filter on aggregated results, you need to use HAVING.

-- Correct usage with HAVING:
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- You can also use aliases in the HAVING clause:
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- Note: `HAVING` is used to filter after grouping, while `WHERE` is used to filter before grouping.

-- LIMIT and ALIASING

-- LIMIT: This clause specifies the maximum number of rows to return from the result set.
-- It’s useful for paginating results or when you only need a subset of the data.

-- Basic usage of LIMIT:
SELECT *
FROM employee_demographics
LIMIT 3;  -- Returns only the first 3 rows.

-- Using LIMIT with ORDER BY to get specific rows in a sorted order:
SELECT *
FROM employee_demographics
ORDER BY first_name
LIMIT 3;  -- Returns the first 3 rows in alphabetical order by first name.

-- LIMIT can also take two parameters: the offset and the number of rows to return.
-- OFFSET specifies where to start, and the number specifies how many rows to fetch.

-- Example: Start at position 3 and return 2 rows:
SELECT *
FROM employee_demographics
ORDER BY first_name
LIMIT 3, 2;  -- Skips the first 3 rows and returns the next 2 rows.

-- Use case: Selecting the third oldest person:
SELECT *
FROM employee_demographics
ORDER BY age DESC;
-- To get the third oldest, use:
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1;  -- Skips the top 2 oldest and returns the next row.

-- ALIASING: This allows you to rename columns or tables for better readability or convenience.

-- Basic aliasing with column names:
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

-- Using AS to explicitly specify an alias:
SELECT gender, AVG(age) AS Avg_age
FROM employee_demographics
GROUP BY gender;

-- You can also use an alias without the AS keyword, which is shorter but less explicit:
SELECT gender, AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender;

-- Aliases make the result set easier to read and can simplify complex queries.
