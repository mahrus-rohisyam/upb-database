-- Resetting Command

-- DROP DATABASE `upb`;

CREATE DATABASE IF NOT EXISTS `upb`;

USE `upb`;

-- SQL DDL
CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    publication_year INT,
    price DECIMAL(10,2),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- ALTER TABLE books
-- 	ADD COLUMN price DECIMAL(10,2);

-- DROP TABLE IF EXISTS books;

-- SQL DML

INSERT INTO authors (name)
VALUES
    ('Harper Lee'),
    ('Jane Austen'),
    ('George Orwell'),
    ('J.D. Salinger'),
    ('J.R.R. Tolkien');

INSERT INTO books (title, author_id, publication_year, price)
VALUES 
  ('To Kill a Mockingbird', 1, 1960, 14.99),
  ('Pride and Prejudice', 2, 1813, 9.99),
  ('1984', 3, 1949, 11.99),
  ('The Catcher in the Rye', 4, 1951, 10.99),
  ('The Lord of the Rings', 5, 1954, 19.99);

UPDATE books
	SET price = 9.99
		WHERE id = 1;

-- SELECT JOIN

SELECT books.title, authors.name
	FROM books
		JOIN authors ON books.author_id = authors.id;

-- CREATE VIEW

CREATE VIEW book_author_view AS
	SELECT books.title, authors.name AS author_name
		FROM books
			JOIN authors ON books.author_id = authors.id;

SELECT * FROM book_author_view;

-- CREATE PROCEDURE
DELIMITER //

DROP PROCEDURE IF EXISTS AddBookWithAuthor //

DELIMITER //

CREATE PROCEDURE AddBookWithAuthor(
    IN book_title VARCHAR(255),
    IN author_name VARCHAR(255),
    IN book_publication_year INT,
    IN book_price DECIMAL(10,2)
)
BEGIN
    DECLARE author_id INT;

    SELECT id INTO author_id
		FROM authors
			WHERE name = author_name;
    
    IF author_id IS NULL THEN
        INSERT INTO authors (name)
			VALUES (author_name);
        
        SET author_id = LAST_INSERT_ID();
    END IF;
    
    INSERT INTO books (title, author_id, publication_year, price)
    VALUES (book_title, author_id, book_publication_year, book_price);
END //
DELIMITER ;

CALL AddBookWithAuthor('Bumi', 'Tereliye', 2008, 5.99);

-- CREATE FUNCTION

DELIMITER //
CREATE FUNCTION CalculateTotalPriceByYear(year_val INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(10, 2);

    SELECT SUM(price) INTO total_price
    FROM books
    WHERE publication_year = year_val;

    IF total_price IS NULL THEN
        SET total_price = 0;
    END IF;

    RETURN total_price;
END //
DELIMITER ;

SELECT CalculateTotalPriceByYear(2008);
-- USING MYSQL FUNCTION
