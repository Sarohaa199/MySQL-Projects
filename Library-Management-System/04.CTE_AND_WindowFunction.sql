-- Query 1: Find the most prolific authors.
-- This CTE calculates the number of books each author has written.
WITH AuthorBookCounts AS (
    SELECT author_id, COUNT(*) AS book_count
    FROM books
    GROUP BY author_id
)
-- This main query joins the authors table with the CTE to get the author names and their book counts.
SELECT A.name AS Author_Name, ABC.book_count AS Number_of_Books
FROM authors A
JOIN AuthorBookCounts ABC ON A.author_id = ABC.author_id
ORDER BY ABC.book_count DESC;

-- Query 2: Calculate the running total of books sold for each genre.
-- This CTE calculates the cumulative number of books sold within each genre.
WITH GenreRunningTotal AS (
    SELECT genre_id, title, copies_sold,
           SUM(copies_sold) OVER (PARTITION BY genre_id ORDER BY publication_date) AS running_total
    FROM books
)
-- This main query joins the CTE with the genres table to display each book with its genre and running total.
SELECT G.genre_name AS Genre_Name, B.title AS Book_Title, B.running_total AS Running_Total
FROM GenreRunningTotal B
JOIN genres G ON B.genre_id = G.genre_id
ORDER BY G.genre_name, B.title;

-- Query 3: Calculate the average rating for each book.
-- This CTE calculates the average rating for each book from the ratings table.
WITH BookAverageRatings AS (
    SELECT book_id, AVG(rating) AS average_rating
    FROM ratings
    GROUP BY book_id
)

-- This main query joins the CTE with the books table to display book titles along with their average ratings.
SELECT B.title AS Book_Title, BAR.average_rating AS Average_Rating
FROM books B
JOIN BookAverageRatings BAR ON B.book_id = BAR.book_id
ORDER BY BAR.average_rating DESC;


--Window Functions----

-- Query 1: Rank books based on their average ratings.
-- This query uses the RANK() window function to assign ranks based on average ratings.
SELECT B.title AS Book_Title, 
       AVG(R.rating) AS Average_Rating,
       RANK() OVER (ORDER BY AVG(R.rating) DESC) AS Rank
FROM Books B
JOIN Ratings R ON B.book_id = R.book_id
GROUP BY B.title
ORDER BY Rank;

-- Query 2: Calculate a running total of ratings for each genre.
-- This query uses the SUM() window function to calculate the running total of ratings by genre.
SELECT G.genre_name AS Genre_Name, 
       B.title AS Book_Title, 
       SUM(R.rating) OVER (PARTITION BY G.genre_name ORDER BY B.title) AS Running_Total_Ratings
FROM Books B
JOIN Genres G ON B.genre_id = G.genre_id
JOIN Ratings R ON B.book_id = R.book_id
ORDER BY Genre_Name, Book_Title;

-- Query 3: Analyze average ratings trends over years.
-- This query uses the AVG() window function to calculate average ratings per year.
SELECT YEAR(B.publication_date) AS Year, 
       B.title AS Book_Title, 
       AVG(R.rating) OVER (PARTITION BY YEAR(B.publication_date)) AS Average_Rating
FROM Books B
JOIN Ratings R ON B.book_id = R.book_id
ORDER BY Year, Book_Title;
