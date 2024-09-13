-- Create the database if it does not already exist
CREATE DATABASE IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

-- Create the Authors table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each author
    name VARCHAR(255) NOT NULL,                -- Author's name
    birthdate DATE                             -- Author's birthdate
);

-- Create the Genres table
CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each genre
    genre_name VARCHAR(255) NOT NULL           -- Genre name
);

-- Create the Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each book
    title VARCHAR(1000) NOT NULL,               -- Title of the book
    author_id INT,                             -- Foreign key to Authors table
    genre_id INT,                              -- Foreign key to Genres table
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- Create the Rating table
CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    rating DECIMAL(3,2),   -- Example: rating out of 5.00
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
