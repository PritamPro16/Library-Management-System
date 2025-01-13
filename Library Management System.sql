USE LibraryDB;
CREATE TABLE Books(
Book_id INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR(255) NOT NULL,
Catagory_id INT,
Available_copies INT NOT NULL,
Total_copies INT NOT NULL
);

USE LibraryDB;
CREATE TABLE Authors (
Author_id INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(255) NOT NULL
);

USE LibraryDB;
CREATE TABLE Book_Author (
    Book_id INT,
    Author_id INT,
    PRIMARY KEY (Book_id, Author_id),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Author_id) REFERENCES Authors(Author_id) ON DELETE CASCADE
);
USE LibraryDB;
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
USE LibraryDB;
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(50) UNIQUE NOT NULL,
    join_date DATE DEFAULT (CURRENT_DATE)
);
CREATE TABLE Borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);
*/ Example Datas */
INSERT INTO Categories (name) VALUES 
('Fiction'),
('Non-Fiction'),
('Science'),
('History');
INSERT INTO Authors (name) VALUES 
('J.K. Rowling'),
('George Orwell'),
('Isaac Newton'),
('Yuval Noah Harari');
select * from authors;
USE LibraryDB;
INSERT INTO Books (title, catagory_id, available_copies, total_copies) VALUES 
('Harry Potter', 1, 5, 5),
('1984', 1, 3, 3),
('Principia Mathematica', 3, 2, 2),
('Sapiens', 2, 4, 4);

USE LibraryDB;
INSERT INTO Book_Author (book_id, author_id) VALUES 
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- 1984 by George Orwell
(3, 3), -- Principia Mathematica by Isaac Newton
(4, 4); -- Sapiens by Yuval Noah Harari

INSERT INTO Members (name, contact) VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO Borrowings (member_id, book_id, borrow_date, return_date) VALUES 
(1, 1, '2025-01-01', NULL), -- Alice borrowed Harry Potter
(2, 2, '2025-01-05', '2025-01-10'), -- Bob borrowed and returned 1984
(3, 3, '2025-01-03', NULL); -- Charlie borrowed Principia Mathematica

SELECT * FROM Books;
SELECT m.name AS Member, b.title AS Book
FROM Borrowings br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE m.name = 'Alice';

SELECT b.title AS Book, m.name AS Member, br.borrow_date
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL AND br.borrow_date < DATE_SUB(CURRENT_DATE, INTERVAL 14 DAY);

SELECT b.title, COUNT(br.book_id) AS Borrow_Count
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
GROUP BY br.book_id
ORDER BY Borrow_Count DESC;

USE LibraryDB;
DELIMITER $$

CREATE TRIGGER Before_Borrow
BEFORE INSERT ON Borrowings
FOR EACH ROW
BEGIN
    UPDATE Books
    SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id AND available_copies > 0;
END$$

DELIMITER ;




