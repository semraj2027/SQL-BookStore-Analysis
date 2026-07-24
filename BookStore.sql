select * from books;

select * from customers;

select * from orders;

ALTER TABLE books ADD PRIMARY KEY (Book_ID);

ALTER TABLE customers ADD PRIMARY KEY (Customer_ID);

ALTER TABLE orders ADD PRIMARY KEY (Order_ID);

ALTER TABLE orders 
ADD CONSTRAINT fk_book
FOREIGN KEY(Book_ID)
REFERENCES books(Book_ID);

ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (Customer_ID)
REFERENCES customers(Customer_ID);





-- ===========================
-- BASIC QUERIES
-- ===========================

-- 1. Retrieve all books in the "Fiction" genre
SELECT *
FROM Books
WHERE Genre = 'Fiction';

-- 2. Find books published after the year 1950
SELECT *
FROM Books
WHERE Published_Year > 1950;

-- 3. List all customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4. Show orders placed in November 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6. Find the details of the most expensive book
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7. Show all customers who ordered more than 1 quantity
SELECT *
FROM Orders
WHERE Quantity > 1;

-- 8. Retrieve all orders where the total amount exceeds $20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9. List all available genres
SELECT DISTINCT Genre
FROM Books;

-- 10. Find the book with the lowest stock
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11. Calculate the total revenue
SELECT SUM(Total_Amount) AS Revenue
FROM Orders;




-- ===========================
-- ADVANCED QUERIES
-- ===========================

-- 1. Total number of books sold for each genre
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- 2. Average price of Fantasy books
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3. Customers who placed at least 2 orders
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Order_Count
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 4. Most frequently ordered book
SELECT
    b.Book_ID,
    b.Title,
    COUNT(o.Order_ID) AS Order_Count
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 5. Top 3 most expensive Fantasy books
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6. Total quantity of books sold by each author
SELECT
    b.Author,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Author;

-- 7. Cities where customers spent more than $30 on an order
SELECT DISTINCT
    c.City
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount > 30;

-- 8. Customer who spent the most
SELECT
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9. Calculate remaining stock after fulfilling all orders
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity),0) AS Ordered_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
ORDER BY b.Book_ID;
