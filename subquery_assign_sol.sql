
USE sakila;

-- 1. Display all customer details who have made more than 5 payments.
SELECT *
FROM sakila.customer
WHERE customer_id IN (
    SELECT customer_id
    FROM sakila.payment
    GROUP BY customer_id
    HAVING COUNT(*) > 5
);


-- 2. Find the names of actors who have acted in more than 10 films.
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);


-- 3. Find the names of customers who never made a payment.
SELECT customer_id, first_name, last_name
FROM sakila.customer
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sakila.payment
    WHERE customer_id IS NOT NULL
);


-- 4. List all films whose rental rate is higher than the average rental rate.
SELECT title, rental_rate
FROM sakila.film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM sakila.film
);


-- 5. List the titles of films that were never rented.
SELECT title
FROM sakila.film
WHERE film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM sakila.inventory i
    JOIN sakila.rental r
        ON i.inventory_id = r.inventory_id
);


-- 6. Display customers who rented films in the same month as customer ID 5.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM sakila.customer c
JOIN sakila.rental r
    ON c.customer_id = r.customer_id
WHERE DATE_FORMAT(r.rental_date, '%Y-%m') IN (
    SELECT DATE_FORMAT(rental_date, '%Y-%m')
    FROM sakila.rental
    WHERE customer_id = 5
);


-- 7. Find staff members who handled a payment greater than the average.
SELECT *
FROM sakila.staff
WHERE staff_id IN (
    SELECT staff_id
    FROM sakila.payment
    WHERE amount > (
        SELECT AVG(amount)
        FROM sakila.payment
    )
);


-- 8. Show the title and rental duration of films whose rental duration is greater than the average.
SELECT title, rental_duration
FROM sakila.film
WHERE rental_duration > (
    SELECT AVG(rental_duration)
    FROM sakila.film
);


-- 9. Find customers who share the same address as customer ID 1.
SELECT *
FROM sakila.customer
WHERE address_id = (
    SELECT address_id
    FROM sakila.customer
    WHERE customer_id = 1
);
-- AND customer_id != 1;


-- 10. List all payments greater than the average payment amount.
SELECT *
FROM sakila.payment
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment
);
