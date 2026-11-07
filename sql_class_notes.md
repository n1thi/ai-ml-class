# SQL Class Notes (MySQL)

## 1. Core ideas

- Database: a structured collection of data.
- DBMS: software that manages databases, like MySQL.
- SQL: language used to work with data.
- Schema: the layout or structure of a database.

Common SQL groups:
- DDL: create/alter/drop database objects
- DML: insert/update/delete data
- DQL: read data with SELECT
- DCL: grant/revoke permissions
- TCL: commit/rollback transactions

## 2. Tables and constraints

```sql
CREATE DATABASE company_db;
USE company_db;

CREATE TABLE company_db.people (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT CHECK (age >= 18),
    city VARCHAR(50) DEFAULT 'New York'
);
```

Important constraints:
- PRIMARY KEY: unique, non-null key for each row
- FOREIGN KEY: links tables together
- NOT NULL: value must exist
- UNIQUE: no duplicate values
- CHECK: enforces conditions
- DEFAULT: value used if none is given

Example with a foreign key:

```sql
CREATE TABLE company_db.orders (
    order_id INT PRIMARY KEY,
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES company_db.people(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
```

Quick rule:
- DELETE removes selected rows
- TRUNCATE removes all rows quickly
- DROP removes the whole table

## 3. SELECT basics

```sql
SELECT DISTINCT rating FROM sakila.film;
SELECT title, rental_rate FROM sakila.film
WHERE rating IN ('G', 'PG') AND rental_rate BETWEEN 1 AND 4
ORDER BY rental_rate DESC LIMIT 10;

SELECT title FROM sakila.film WHERE title LIKE '%super%';
SELECT rental_id FROM sakila.rental WHERE return_date IS NULL;
```

- SELECT picks columns
- DISTINCT removes duplicate result rows
- WHERE filters rows
- AND / OR / NOT combine conditions
- IN matches a list
- BETWEEN includes both ends
- LIKE lets you match patterns
- % = any number of characters
- _ = one character
- IS NULL / IS NOT NULL is used instead of = NULL
- ORDER BY sorts rows
- LIMIT keeps only a few rows
- CASE can create custom labels

## 4. Aggregates and grouping

```sql
SELECT customer_id, COUNT(*) AS payment_count,
       SUM(amount) AS total_paid
FROM sakila.payment
WHERE amount > 0
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_paid DESC;
```

Common functions:
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

Key points:
- GROUP BY groups rows together
- Aggregate functions run per group
- WHERE filters before grouping
- HAVING filters after grouping

Logical order:
FROM / JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

## 5. Dates and times

```sql
SELECT DATEDIFF(return_date, rental_date) AS days_rented
FROM sakila.rental WHERE return_date IS NOT NULL;

SELECT DATE(payment_date), YEAR(payment_date), MONTH(payment_date)
FROM sakila.payment;

SELECT NOW(), CURDATE(), CURRENT_TIME();
```

Useful functions:
- DATEDIFF(end, start)
- DATE()
- YEAR(), MONTH(), DAY()
- NOW(), CURDATE(), CURRENT_TIME()
- CONCAT() joins text

## 6. Subqueries

A subquery is a query inside another query.

```sql
SELECT customer_id, amount
FROM sakila.payment
WHERE amount > (SELECT AVG(amount) FROM sakila.payment);

SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id FROM sakila.film_actor
    GROUP BY actor_id HAVING COUNT(*) > 10
);
```

Types:
- Scalar subquery: returns one value
- IN subquery: returns multiple values
- Correlated subquery: uses values from the outer query

## 7. Joins

Joins connect rows from different tables using related keys.

Common join types:
- INNER JOIN: only matching rows
- LEFT JOIN: all left rows, nulls on the right if no match
- RIGHT JOIN: all right rows
- CROSS JOIN: all combinations
- Self join: join a table to itself

Example:

```sql
SELECT c.customer_id, c.first_name
FROM sakila.customer c
LEFT JOIN sakila.payment p ON p.customer_id = c.customer_id
WHERE p.payment_id IS NULL;
```

Important:
- If one side has many matching rows, joins can multiply rows
- DISTINCT only removes duplicate full rows

## 8. CTEs

A CTE is a temporary named result used inside a query.

```sql
WITH payment_counts AS (
    SELECT customer_id, COUNT(*) AS n
    FROM sakila.payment
    GROUP BY customer_id
)
SELECT customer_id, n
FROM payment_counts
WHERE n > 5;
```

Use CTEs when a query has multiple steps and is easier to read.

## 9. Views and temporary tables

- Temporary table: stores intermediate data for the current session
- View: saved SELECT definition that acts like a table

```sql
CREATE TEMPORARY TABLE sakila.big_payments AS
SELECT * FROM sakila.payment WHERE amount > 10;

CREATE OR REPLACE VIEW sakila.customer_last_rental AS
SELECT customer_id, MAX(rental_date) AS last_rental
FROM sakila.rental
GROUP BY customer_id;
```

## 10. Stored procedures

A stored procedure is reusable SQL logic saved in the database.

```sql
DELIMITER //
CREATE PROCEDURE sakila.TotalPaid(IN cid INT, OUT total DECIMAL(10,2))
BEGIN
    SELECT COALESCE(SUM(amount), 0) INTO total
    FROM sakila.payment WHERE customer_id = cid;
END //
DELIMITER ;

CALL sakila.TotalPaid(8, @total);
SELECT @total;
```

Parameters:
- IN: input value
- OUT: returns a value
- INOUT: both

## 11. Quick decision guide

- Use subquery when you need to compare with another result
- Use JOIN when combining tables
- Use CTE for readable multi-step queries
- Use temporary table for intermediate data
- Use view for a saved query
- Use stored procedure for reusable logic

## 12. Safety reminders

- Always use a specific WHERE in UPDATE / DELETE
- Be careful with foreign keys; they can block deletes
- Use DECIMAL for money, not FLOAT
- Prefer set-based SQL over looping when possible
