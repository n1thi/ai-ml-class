
USE sakila;

-- 1. Show customers who have made more than 5 payments
SELECT c.*
FROM customer c
WHERE (
    SELECT COUNT(*)
    FROM payment p
    WHERE p.customer_id = c.customer_id
) > 5;


-- 2. Find actors who have appeared in more than 10 films
SELECT a.first_name, a.last_name
FROM actor a
WHERE (
    SELECT COUNT(*)
    FROM film_actor fa
    WHERE fa.actor_id = a.actor_id
) > 10;


-- 3. Find customers who never made a payment
SELECT c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM payment p
    WHERE p.customer_id = c.customer_id
);


-- 4. List films with a rental rate above the overall average
SELECT f.title, f.rental_rate
FROM film f
WHERE f.rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);


-- 5. List films that were never rented
SELECT f.title
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    JOIN rental r
      ON r.inventory_id = i.inventory_id
    WHERE i.film_id = f.film_id
);


-- 6. Show customers who rented films in the same month as customer 5
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r
  ON r.customer_id = c.customer_id
WHERE EXISTS (
    SELECT 1
    FROM rental r5
    WHERE r5.customer_id = 5
      AND YEAR(r5.rental_date) = YEAR(r.rental_date)
      AND MONTH(r5.rental_date) = MONTH(r.rental_date)
)
AND c.customer_id <> 5;


-- 7. Find staff members who handled a payment above the average amount
SELECT DISTINCT s.staff_id, s.first_name, s.last_name
FROM staff s
JOIN payment p
  ON p.staff_id = s.staff_id
WHERE p.amount > (
    SELECT AVG(amount)
    FROM payment
);


-- 8. Show films whose rental duration is greater than the average
SELECT f.title, f.rental_duration
FROM film f
WHERE f.rental_duration > (
    SELECT AVG(rental_duration)
    FROM film
);


-- 9. Find customers who live at the same address as customer 1
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.address_id = (
    SELECT address_id
    FROM customer
    WHERE customer_id = 1
)
AND c.customer_id <> 1;


-- 10. List all payments above the average payment amount
SELECT p.*
FROM payment p
WHERE p.amount > (
    SELECT AVG(amount)
    FROM payment
);
