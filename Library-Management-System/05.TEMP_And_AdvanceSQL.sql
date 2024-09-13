-- Temporary Table --

-- Query 1: Create a temporary table to store book details with ratings
-- This table combines book details and their average ratings.
CREATE TEMPORARY TABLE TempBookDetails AS
SELECT B.title AS Book_Title, 
       G.genre_name AS Genre_Name, 
       AVG(R.rating) AS Average_Rating
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
LEFT JOIN Ratings R ON B.book_id = R.book_id
GROUP BY B.title, G.genre_name;

-- Query 2: Query the temporary table to find books with average ratings above 4.0
-- This retrieves books with an average rating greater than 4.0 from the temporary table.
SELECT Book_Title, Genre_Name, Average_Rating
FROM TempBookDetails
WHERE Average_Rating > 4.0;

-- Query 3: Create a temporary table to store author statistics
-- This calculates the number of books each author has written.
CREATE TEMPORARY TABLE TempAuthorStats AS
SELECT A.name AS Author_Name, 
       COUNT(B.book_id) AS Book_Count
FROM Authors A
JOIN Books B ON A.author_id = B.author_id
GROUP BY A.name;

-- Query 4: Query the temporary table to find the top 5 authors with the most books
-- This retrieves the top 5 authors with the highest book count.
SELECT Author_Name, Book_Count
FROM TempAuthorStats
ORDER BY Book_Count DESC
LIMIT 5;

-- Query 5: Drop temporary tables to clean up
-- This command drops the temporary tables after use.
DROP TEMPORARY TABLE IF EXISTS TempBookDetails;
DROP TEMPORARY TABLE IF EXISTS TempAuthorStats;

--Union--
-- Query 6: Combine books in the genres "Science Fiction" and "Fantasy"
-- This query lists books from both specified genres.
SELECT B.title AS Book_Title, G.genre_name AS Genre_Name
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
WHERE G.genre_name = 'Science Fiction'

UNION

SELECT B.title AS Book_Title, G.genre_name AS Genre_Name
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
WHERE G.genre_name = 'Fantasy';

-- Query 7: Union results for books published before and after 2000
-- This query combines books published before and after the year 2000.
SELECT B.title AS Book_Title, B.publication_date AS Publication_Date, G.genre_name AS Genre_Name
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
WHERE B.publication_date < '2000-01-01'

UNION ALL

SELECT B.title AS Book_Title, B.publication_date AS Publication_Date, G.genre_name AS Genre_Name
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
WHERE B.publication_date >= '2000-01-01';


--Stored Procedure--
-- Query 8: Create a stored procedure to get books by a specific author
-- This stored procedure retrieves books written by a specific author.
DELIMITER $$

CREATE PROCEDURE GetBooksByAuthor(IN authorName VARCHAR(255))
BEGIN
    SELECT B.title AS Book_Title, G.genre_name AS Genre_Name
    FROM Books B
    JOIN Authors A ON B.author_id = A.author_id
    JOIN Genres G ON B.genre_id = G.genre_id
    WHERE A.name = authorName;
END$$

DELIMITER ;

-- To call the stored procedure:
-- CALL GetBooksByAuthor('George Orwell');

-- Query 9: Create a stored procedure to get average rating for a book
-- This stored procedure calculates the average rating for a specific book.
DELIMITER $$

CREATE PROCEDURE GetBookAverageRating(IN bookTitle VARCHAR(1000))
BEGIN
    SELECT B.title AS Book_Title, 
           AVG(R.rating) AS Average_Rating
    FROM Books B
    LEFT JOIN Ratings R ON B.book_id = R.book_id
    WHERE B.title = bookTitle
    GROUP BY B.title;
END$$

DELIMITER ;

-- To call the stored procedure:
-- CALL GetBookAverageRating('1984');

-- Query 10: Filter books published in the last 10 years
-- This query retrieves books published within the last decade.
SELECT B.title AS Book_Title, B.publication_date AS Publication_Date, G.genre_name AS Genre_Name
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
WHERE B.publication_date >= CURDATE() - INTERVAL 10 YEAR;

-- Query 11: Count the number of books sold in each genre where the count exceeds 1000
-- This retrieves genre counts only for genres with more than 1000 books sold.
-- Note: Requires a sales table or equivalent data, example provided here.
-- Example:
 SELECT G.genre_name AS Genre_Name, COUNT(B.book_id) AS Number_Of_Books
 FROM Books B
 JOIN Genres G ON B.genre_id = G.genre_id
 GROUP BY G.genre_name
 HAVING COUNT(B.book_id) > 1000;

-- Query 12: Analyze genre popularity over the last 5 years
-- This example calculates total sales for each genre within the last 5 years.
-- Example Query:
 SELECT G.genre_name AS Genre_Name, 
        SUM(S.sales_amount) AS Total_Sales
 FROM Genres G
 JOIN Books B ON G.genre_id = B.genre_id
 JOIN Sales S ON B.book_id = S.book_id
 WHERE S.sale_date >= CURDATE() - INTERVAL 5 YEAR
 GROUP BY G.genre_name;

-- Query 13: Determine how the number of books published by authors has changed over time
-- This example shows book publication trends by author over the years.
-- Example Query:
 SELECT A.name AS Author_Name, 
        YEAR(B.publication_date) AS Publication_Year, 
        COUNT(B.book_id) AS Number_Of_Books
 FROM Authors A
 JOIN Books B ON A.author_id = B.author_id
 GROUP BY A.name, YEAR(B.publication_date)
 ORDER BY A.name, Publication_Year;

-- Query 14: Compare books based on average ratings and sales
-- This example compares books by their average ratings and sales.
-- Example Query:
 SELECT B.title AS Book_Title, 
        AVG(R.rating) AS Average_Rating, 
        SUM(S.sales_amount) AS Total_Sales
 FROM Books B
 JOIN Ratings R ON B.book_id = R.book_id
 JOIN Sales S ON B.book_id = S.book_id
 GROUP BY B.title;
