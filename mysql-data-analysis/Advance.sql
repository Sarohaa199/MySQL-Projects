-- Using Common Table Expressions (CTE)
-- A CTE allows you to define a subquery block that can be referenced within the main query.
-- It is particularly useful for recursive queries or queries that require referencing a higher level
-- this is something we will look at in the next lesson/

-- Let's take a look at the basics of writing a CTE:

-- First, CTEs start using a "WITH" keyword. Now we get to name this CTE anything we want
-- Then we say AS and within the parenthesis we build our subquery/table we want
WITH CTE_Example AS 
(
    SELECT gender, SUM(salary) AS total_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary, COUNT(salary) AS count_salary, AVG(salary) AS avg_salary
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
-- directly after using it we can query the CTE
SELECT *
FROM CTE_Example;

-- Now if I come down here, it won't work because it's not using the same syntax
-- SELECT *
-- FROM CTE_Example;

-- Now we can use the columns within this CTE to do calculations on this data that
-- we couldn't have done without it.
WITH CTE_Example AS 
(
    SELECT gender, SUM(salary) AS total_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary, COUNT(salary) AS count_salary
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
-- notice here I have to use backticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(total_salary / count_salary), 2) AS avg_salary_per_employee
FROM CTE_Example
GROUP BY gender;

-- we also have the ability to create multiple CTEs with just one WITH expression
WITH CTE_Example AS 
(
    SELECT employee_id, gender, birth_date
    FROM employee_demographics dem
    WHERE birth_date > '1985-01-01'
), -- just have to separate by using a comma
CTE_Example2 AS 
(
    SELECT employee_id, salary
    FROM parks_and_recreation.employee_salary
    WHERE salary >= 50000
)
-- Now if we change this a bit, we can join these two CTEs together
SELECT *
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
    ON cte1.employee_id = cte2.employee_id;

-- the last thing I wanted to show you is that we can actually make our life easier by renaming the columns in the CTE
-- let's take our very first CTE we made. We had to use backticks because of the column names

-- we can rename them like this
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
    SELECT gender, SUM(salary) AS sum_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary, COUNT(salary) AS count_salary
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
-- notice here I don't have to use backticks for column names
SELECT gender, ROUND(AVG(sum_salary / count_salary), 2) AS avg_salary_per_employee
FROM CTE_Example
GROUP BY gender;

-- Using Temporary Tables
-- Temporary tables are used to store intermediate results or manipulate data within the scope of a session.
-- They are only visible to the session that created them and are automatically dropped when the session ends.

-- There are two common methods to create temporary tables:

-- Method 1: Create a temporary table with a defined schema and insert data into it.
CREATE TEMPORARY TABLE temp_table
(
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    favorite_movie VARCHAR(100)
);

-- Query the temporary table. It will be empty initially.
SELECT *
FROM temp_table;

-- Insert data into the temporary table.
INSERT INTO temp_table (first_name, last_name, favorite_movie)
VALUES ('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');

-- Query the temporary table to see the inserted data.
SELECT *
FROM temp_table;

-- Method 2: Create a temporary table by directly selecting data into it.
CREATE TEMPORARY TABLE salary_over_50k AS
SELECT *
FROM employee_salary
WHERE salary > 50000;

-- Query the newly created temporary table.
SELECT *
FROM salary_over_50k;

-- Temporary tables are particularly useful for breaking down complex queries into manageable steps,
-- or for storing intermediate results that will be used later in the session.

-- Example use case: Calculate average salary by department using temporary tables.

-- Step 1: Create a temporary table with salary data by department.
CREATE TEMPORARY TABLE department_salaries AS
SELECT dept_id, AVG(salary) AS avg_salary
FROM employee_salary
GROUP BY dept_id;

-- Step 2: Use the temporary table to get details of departments with an average salary above a certain threshold.
SELECT dept_id, avg_salary
FROM department_salaries
WHERE avg_salary > 60000;

-- Temporary tables are dropped automatically at the end of the session,
-- but you can also drop them manually if needed.
DROP TEMPORARY TABLE IF EXISTS temp_table;
DROP TEMPORARY TABLE IF EXISTS salary_over_50k;
DROP TEMPORARY TABLE IF EXISTS department_salaries;

-- Creating a Basic Stored Procedure

-- Start with a simple query
SELECT *
FROM employee_salary
WHERE salary >= 60000;

-- Now encapsulate this query into a stored procedure
CREATE PROCEDURE large_salaries()
BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= 60000;
END;

-- To execute the stored procedure, use:
CALL large_salaries();

-- -------------------------------------------
-- Adding More Complex Queries

-- Adding multiple queries in a procedure requires using the DELIMITER command.
-- This allows you to define a custom delimiter (e.g., $$) so that the SQL parser doesn't misinterpret the end of the procedure.
-- Default delimiter is a semicolon (;), so you need to change it to avoid conflicts.

-- Change delimiter to $$
DELIMITER $$

-- Create a stored procedure with multiple queries
CREATE PROCEDURE large_salaries2()
BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= 60000;

    SELECT *
    FROM employee_salary
    WHERE salary >= 50000;
END $$

-- Reset delimiter to default
DELIMITER ;

-- Call the newly created stored procedure
CALL large_salaries2();

-- -------------------------------------------
-- Creating Stored Procedures via GUI

-- You can also create stored procedures using a GUI tool, which automatically manages delimiters.
-- For example, using MySQL Workbench:
USE `parks_and_recreation`;
DROP PROCEDURE IF EXISTS `large_salaries3`;

-- The GUI tool will handle the delimiter for you.
CREATE PROCEDURE large_salaries3()
BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= 60000;
    
    SELECT *
    FROM employee_salary
    WHERE salary >= 50000;
END;

-- Call the stored procedure
CALL large_salaries3();

-- -------------------------------------------
-- Adding Parameters to Stored Procedures

-- Parameters allow you to make your stored procedure more dynamic.
-- For instance, you might want to filter by a specific employee ID.

USE `parks_and_recreation`;
DROP PROCEDURE IF EXISTS `large_salaries_with_param`;

-- Create a stored procedure with a parameter
DELIMITER $$
CREATE PROCEDURE large_salaries_with_param(IN min_salary INT)
BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= min_salary;
END $$

-- Reset delimiter to default
DELIMITER ;

-- Call the stored procedure with a parameter
CALL large_salaries_with_param(60000);

-- The above call will return salaries greater than or equal to 60000.

-- -------------------------------------------
-- Parameter Types and Usage

-- IN: Pass values into the procedure.
-- OUT: Retrieve values from the procedure.
-- INOUT: Pass values in and retrieve values out.

-- Example with OUT parameter
USE `parks_and_recreation`;
DROP PROCEDURE IF EXISTS `employee_count_in_department`;

DELIMITER $$
CREATE PROCEDURE employee_count_in_department(IN dept_id INT, OUT emp_count INT)
BEGIN
    SELECT COUNT(*) INTO emp_count
    FROM employee_salary
    WHERE dept_id = dept_id;
END $$

DELIMITER ;

-- Call the stored procedure with IN and OUT parameters
CALL employee_count_in_department(1, @emp_count);

-- Retrieve the OUT parameter value
SELECT @emp_count;

-- Triggers

-- A trigger is a block of code that automatically executes in response to specific changes in a table.
-- For instance, we want to update the invoice when a new payment is made.

-- First, let's look at the tables we are dealing with:
SELECT * FROM employee_salary;
SELECT * FROM employee_demographics;

-- Suppose we want a trigger to update the `employee_demographics` table whenever a new row is inserted into the `employee_salary` table.
-- This is how you would create such a trigger:

USE parks_and_recreation;
DELIMITER $$

CREATE TRIGGER after_employee_salary_insert
    AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
    -- Insert the new employee data into the employee_demographics table
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;

-- The trigger `after_employee_salary_insert` is now set up to execute after each new row is inserted into `employee_salary`.

-- Let's test the trigger:
-- Insert a new employee into the `employee_salary` table
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

-- Check the `employee_demographics` table to see if the new employee data has been inserted
SELECT * FROM employee_demographics;

-- To remove the test data
DELETE FROM employee_salary WHERE employee_id = 13;

-- -------------------------------------------------------------------------

-- Events

-- Events are scheduled tasks that execute automatically at specified intervals or times.
-- They are useful for routine maintenance, data imports, or scheduled reporting.

-- Let’s create an event that deletes employees over the age of 60 from the `employee_demographics` table.

-- First, check existing events:
SHOW EVENTS;

-- If an event already exists with the same name, drop it:
DROP EVENT IF EXISTS delete_retirees;

-- Create a new event to delete retirees every 30 seconds (for testing purposes; adjust frequency as needed)
DELIMITER $$

CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    DELETE FROM parks_and_recreation.employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;

-- After creating the event, wait for it to execute or manually trigger it (depending on the interval).
-- Verify the effect by querying the `employee_demographics` table:
SELECT * FROM parks_and_recreation.employee_demographics;

-- Note: Adjust event schedules for real-world applications to prevent excessive load or unintended data loss.

-- To stop the event, you can either drop it or alter its schedule:
-- DROP EVENT delete_retirees;
-- ALTER EVENT delete_retirees DISABLE;
