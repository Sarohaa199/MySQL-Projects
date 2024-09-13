-- Joins in SQL

-- Inner Join
-- An inner join returns rows where there is a match in both tables.
-- Example with employee_demographics and employee_salary tables:
SELECT *
FROM employee_demographics
INNER JOIN employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- Note: Rows that don't have a matching employee_id in both tables will not appear in the result.

-- Left Join (or Left Outer Join)
-- A left join returns all rows from the left table and the matched rows from the right table.
-- If there is no match, the result is NULL for columns from the right table.
SELECT *
FROM employee_salary sal
LEFT JOIN employee_demographics dem
    ON dem.employee_id = sal.employee_id;

-- Note: This includes all rows from employee_salary. If an employee in employee_salary
-- doesn't have a corresponding record in employee_demographics, those fields will be NULL.

-- Right Join (or Right Outer Join)
-- A right join returns all rows from the right table and the matched rows from the left table.
-- If there is no match, the result is NULL for columns from the left table.
SELECT *
FROM employee_salary sal
RIGHT JOIN employee_demographics dem
    ON dem.employee_id = sal.employee_id;

-- Note: This includes all rows from employee_demographics. If there’s no matching record
-- in employee_salary, those fields will be NULL.

-- Self Join
-- A self join is when a table is joined with itself.
-- Example: Creating a "Secret Santa" list where each employee gives a gift to the next employee.
SELECT emp1.employee_id AS emp_santa,
       emp1.first_name AS santa_first_name,
       emp1.last_name AS santa_last_name,
       emp2.employee_id,
       emp2.first_name,
       emp2.last_name
FROM employee_salary emp1
JOIN employee_salary emp2
    ON emp1.employee_id + 1 = emp2.employee_id;

-- Note: This query pairs each employee with the next one in line. For example, Leslie will be Ron's Secret Santa.

-- Joining Multiple Tables
-- Join more than two tables. Example with employee_demographics, employee_salary, and parks_departments tables.
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
JOIN parks_departments dept
    ON dept.department_id = sal.dept_id;

-- Note: This inner join excludes rows from employee_salary that don’t have corresponding entries in parks_departments.
-- Use a left join to include all rows from employee_salary even if they don’t belong to any department.
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
LEFT JOIN parks_departments dept
    ON dept.department_id = sal.dept_id;

-- Note: This ensures that every employee's salary information is included, even if they don't belong to any department.

-- UNIONS

-- UNION combines the result sets of two or more SELECT statements into a single result set.
-- The result set includes all the rows from each SELECT statement, combined into a single result set.
-- Note: The columns in the SELECT statements must have the same number and compatible data types.

-- Example of combining different data sets (not recommended for real scenarios):
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT occupation, salary
FROM employee_salary;

-- This example combines rows from two different tables with different columns, resulting in a mix of unrelated data.

-- Combining identical columns from two SELECT statements:
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- UNION removes duplicate rows by default. This is equivalent to UNION DISTINCT:
SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

-- Using UNION ALL to include all rows, including duplicates:
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

-- Practical use case for UNION:
-- Assume Parks Department wants to identify older or high-paid employees for budget cuts.

-- Find older employees:
SELECT first_name, last_name, 'Old' AS Label
FROM employee_demographics
WHERE age > 50;

-- Find older female employees, older male employees, and highly paid employees:
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary >= 70000
ORDER BY first_name;

-- Note: UNION combines the result sets, and ORDER BY applies to the final result set after the UNION operation.

-- STRING FUNCTIONS

-- Display all rows from the bakery.customers table
SELECT * 
FROM bakery.customers;

-- LENGTH: Returns the length of a string
SELECT LENGTH('sky');

-- Length of each first name in the employee_demographics table
SELECT first_name, LENGTH(first_name) 
FROM employee_demographics;

-- UPPER: Converts all characters in the string to uppercase
SELECT UPPER('sky');

-- Convert first names to uppercase
SELECT first_name, UPPER(first_name) 
FROM employee_demographics;

-- LOWER: Converts all characters in the string to lowercase
SELECT LOWER('sky');

-- Convert first names to lowercase
SELECT first_name, LOWER(first_name) 
FROM employee_demographics;

-- TRIM: Removes leading and trailing whitespace from a string
SELECT TRIM('   sky   ');

-- LTRIM: Removes leading whitespace from a string
SELECT LTRIM('     I love SQL');

-- RTRIM: Removes trailing whitespace from a string
SELECT RTRIM('I love SQL    ');

-- LEFT: Extracts a specified number of characters from the left side of the string
SELECT LEFT('Alexander', 4);

-- Extract the first 4 characters of each first name
SELECT first_name, LEFT(first_name, 4) 
FROM employee_demographics;

-- RIGHT: Extracts a specified number of characters from the right side of the string
SELECT RIGHT('Alexander', 6);

-- Extract the last 4 characters of each first name
SELECT first_name, RIGHT(first_name, 4) 
FROM employee_demographics;

-- SUBSTRING: Extracts a substring from a string starting at a specified position and length
SELECT SUBSTRING('Alexander', 2, 3);

-- Extract the year from the birth_date column
SELECT birth_date, SUBSTRING(birth_date, 1, 4) AS birth_year
FROM employee_demographics;

-- REPLACE: Replaces occurrences of a substring within a string
SELECT REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

-- LOCATE: Finds the position of a substring within a string
SELECT LOCATE('x', 'Alexander');

-- LOCATE returns the position of the first occurrence of 'e'
SELECT LOCATE('e', 'Alexander');

-- Locate the position of 'a' in each first name
SELECT first_name, LOCATE('a', first_name) 
FROM employee_demographics;

-- Locate the position of 'Mic' in each first name
SELECT first_name, LOCATE('Mic', first_name) 
FROM employee_demographics;

-- CONCAT: Combines multiple strings into one
SELECT CONCAT('Alex', 'Freberg');

-- Combine first name and last name into a full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

-- CASE STATEMENTS

-- A CASE statement allows you to add conditional logic to your SELECT statements, similar to if-else statements in other programming languages or Excel formulas.

-- Display all rows from the employee_demographics table
SELECT * 
FROM employee_demographics;

-- Basic CASE statement example: Classify employees based on their age
SELECT first_name, 
       last_name, 
       CASE
           WHEN age <= 30 THEN 'Young'
       END AS age_group
FROM employee_demographics;

-- More detailed CASE statement: Classify employees into multiple age groups
SELECT first_name, 
       last_name, 
       CASE
           WHEN age <= 30 THEN 'Young'
           WHEN age BETWEEN 31 AND 50 THEN 'Old'
           WHEN age >= 50 THEN "On Death's Door"
       END AS age_category
FROM employee_demographics;

-- Display all rows from the employee_salary table
SELECT * 
FROM employee_salary;

-- CASE statement with calculations for salary adjustments and bonuses
-- Employees making less than $45k get a 7% raise, otherwise a 5% raise
-- Bonus of 10% for those in the Finance Department (dept_id = 6)
SELECT first_name, 
       last_name, 
       salary,
       CASE
           WHEN salary > 45000 THEN salary + (salary * 0.05)
           WHEN salary <= 45000 THEN salary + (salary * 0.07)
       END AS new_salary,
       CASE
           WHEN dept_id = 6 THEN salary * 0.10
       END AS bonus
FROM employee_salary;

-- Example output with adjusted salaries and bonuses
-- Note: Ben is the only employee getting a bonus

-- SUBQUERIES

-- Subqueries are queries nested inside other queries. They can be used in SELECT, WHERE, and FROM clauses.

-- Display all rows from the employee_demographics table
SELECT *
FROM employee_demographics;

-- Subquery example in the WHERE clause:
-- Find employees who work in the Parks and Rec Department (dept_id = 1) using a subquery
SELECT *
FROM employee_demographics
WHERE employee_id IN 
      (SELECT employee_id
       FROM employee_salary
       WHERE dept_id = 1);

-- Attempting to select more than one column in the subquery will cause an error
-- This is because the IN operator expects a single column to compare against
-- The following will produce an error
-- SELECT *
-- FROM employee_demographics
-- WHERE employee_id IN 
--       (SELECT employee_id, salary
--        FROM employee_salary
--        WHERE dept_id = 1);

-- Subquery example in the SELECT clause:
-- Compare individual salaries to the average salary
-- Note: This query calculates the average salary for the entire table and includes it in the result
SELECT first_name, 
       salary, 
       (SELECT AVG(salary) 
        FROM employee_salary) AS avg_salary
FROM employee_salary;

-- Subquery example in the FROM clause:
-- Create a temporary table to aggregate data and then query from it
-- Note: The subquery must be aliased
SELECT *
FROM (SELECT gender, 
             MIN(age) AS Min_age, 
             MAX(age) AS Max_age, 
             COUNT(age) AS Count_age,
             AVG(age) AS Avg_age
      FROM employee_demographics
      GROUP BY gender) AS Agg_Table;

-- Query the aggregated data from the subquery
-- This calculates the average of the minimum ages per gender
SELECT gender, 
       AVG(Min_age) AS Avg_Min_Age
FROM (SELECT gender, 
             MIN(age) AS Min_age, 
             MAX(age) AS Max_age, 
             COUNT(age) AS Count_age,
             AVG(age) AS Avg_age
      FROM employee_demographics
      GROUP BY gender) AS Agg_Table
GROUP BY gender;

-- WINDOW FUNCTIONS

-- Window functions are powerful tools that allow you to perform calculations across a set of rows related to the current row, 
-- without collapsing the rows into a single output like GROUP BY.

-- Display all rows from the employee_demographics table
SELECT * 
FROM employee_demographics;

-- Group By Example:
-- Calculate the average salary for each gender and group the results
SELECT gender, ROUND(AVG(salary),1) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- Window Function Example:
-- Calculate the average salary for all employees without grouping
SELECT dem.employee_id, dem.first_name, gender, salary,
       AVG(salary) OVER() AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

-- Partition By Example:
-- Calculate the average salary for each gender, similar to GROUP BY but without collapsing rows
SELECT dem.employee_id, dem.first_name, gender, salary,
       AVG(salary) OVER(PARTITION BY gender) AS avg_salary_by_gender
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

-- Running Total Example:
-- Calculate a running total of salaries partitioned by gender, ordered by employee_id
SELECT dem.employee_id, dem.first_name, gender, salary,
       SUM(salary) OVER(PARTITION BY gender ORDER BY employee_id) AS running_total
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

-- Row Number Example:
-- Assign a unique row number to each employee within their gender partition
SELECT dem.employee_id, dem.first_name, gender, salary,
       ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

-- Rank Example:
-- Assign rank to employees within their gender partition based on salary
-- Note: Ranks may have gaps if there are ties
SELECT dem.employee_id, dem.first_name, gender, salary,
       ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

-- Dense Rank Example:
-- Assign dense rank to employees within their gender partition based on salary
-- Note: Dense ranks do not have gaps for ties
SELECT dem.employee_id, dem.first_name, gender, salary,
       ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank,
       DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank
FROM employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id;

