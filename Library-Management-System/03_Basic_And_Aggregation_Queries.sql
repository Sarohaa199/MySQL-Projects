-- Query 1: List all books with their authors and genres.
-- This query joins the 'authors', 'books', and 'genres' tables to display each book along with its author and genre.
-- Results are ordered by the author's name.
SELECT 
    A.name AS Author_Name, 
    B.title AS Book_Title, 
    G.genre_name AS Genre 
FROM 
    authors A 
JOIN 
    books B ON A.author_id = B.author_id  -- Join authors with books based on author_id
JOIN 
    genres G ON B.genre_id = G.genre_id  -- Join books with genres based on genre_id
ORDER BY 
    A.name;  -- Order the results by author's name

-- Query 2: Find all books written by each author and group the results.
-- This query lists each author with the titles of the books they have written.
-- The results are grouped by author name and book title.
-- Note that grouping here doesn’t perform aggregation but lists combinations of authors and book titles.
SELECT 
    A.name AS Author_Name, 
    B.title AS Book_Title 
FROM 
    authors A 
JOIN 
    books B ON A.author_id = B.author_id  -- Join authors with books based on author_id
GROUP BY 
    A.name, B.title  -- Group by author name and book title to get distinct author-book pairs
ORDER BY 
    A.name;  -- Order the results by author's name

-- Query 3: Retrieve a list of all books, their authors, genres, and the author's birthdate.
-- This query joins the 'authors', 'books', and 'genres' tables to display each book along with its author, genre, and the author's birthdate.
-- Results are ordered by the author's name.
SELECT 
    A.name AS Author_Name, 
    B.title AS Book_Title, 
    G.genre_name AS Genre, 
    A.birthdate AS Author_Birthdate 
FROM 
    authors A 
JOIN 
    books B ON A.author_id = B.author_id  -- Join authors with books based on author_id
JOIN 
    genres G ON B.genre_id = G.genre_id  -- Join books with genres based on genre_id
ORDER BY 
    A.name;  -- Order the results by author's name


-- Query 4: Count the number of books in each genre.
-- This query joins the 'genres' and 'books' tables to count the number of books in each genre.
-- Results are grouped by genre name to provide the count of books for each genre.
SELECT 
    G.genre_name AS genre_name, 
    COUNT(B.title) AS Number_of_Books
FROM 
    genres G
JOIN 
    books B ON G.genre_id = B.genre_id
GROUP BY 
    G.genre_name;


-- Query 5: Calculate the average number of books published per genre.
-- This query first counts the number of books in each genre using a subquery.
-- It then calculates the average of these counts to find the average number of books per genre.
SELECT 
    G.genre_name AS genre_name, 
    AVG(BookCount) AS Average_Number_of_Books
FROM (
    -- Subquery to count books per genre
    SELECT 
        G.genre_name AS genre_name, 
        COUNT(B.title) AS BookCount
    FROM 
        genres G
    JOIN 
        books B ON G.genre_id = B.genre_id
    GROUP BY 
        G.genre_name
) AS GenreBookCounts
GROUP BY 
    G.genre_name;

-- Query 6: Determine the average number of books written by authors who have written more than 3 books.
-- This query uses a subquery to filter authors who have written more than 3 books.
-- It then calculates the average number of books written by these authors.
SELECT 
    A.name AS Author_name, 
    AVG(BookCount) AS Average_Books_Per_Author
FROM (
    -- Subquery to count the number of books per author
    SELECT 
        A.name AS Author_name, 
        COUNT(B.title) AS BookCount
    FROM 
        authors A
    JOIN 
        books B ON A.author_id = B.author_id
    GROUP BY 
        A.name
    HAVING 
        COUNT(B.title) > 3
) AS AuthorBookCounts
GROUP BY 
    A.name;
