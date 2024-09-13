-- Insert data into Authors table from CSV file
-- Data file: authors.csv

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/csv_files/authors.csv'
INTO TABLE Authors
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(author_id, name, birthdate);

-- Insert data into Genres table from CSV file
-- Data file: genres.csv

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/csv_files/genres.csv'
INTO TABLE Genres
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(genre_id, genre_name)
SET genre_id = NULL;  -- If you want to auto-increment primary key


-- Insert data into Books table from CSV file
-- Data file: books.csv

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/csv_files/books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(book_id, title, author_id, genre_id)
SET genre_id = NULL; 

-- Insert random ratings into the Ratings table
INSERT INTO Ratings (book_id, rating)
SELECT 
    book_id, 
    ROUND(1 + (RAND() * 4), 2) AS rating -- Generates a rating between 1.00 and 5.00
FROM Books;
