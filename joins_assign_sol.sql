
USE sakila;

-- 1. Show each customer with the films they rented
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    f.title AS film_title
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
JOIN film f
    ON i.film_id = f.film_id
ORDER BY c.customer_id, r.rental_date;


-- 2. Count how many times each customer rented a film
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC, c.customer_id;


-- 3. Show each film with its category
SELECT
    f.film_id,
    f.title,
    c.name AS category_name
FROM film f
LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
LEFT JOIN category c
    ON fc.category_id = c.category_id
ORDER BY f.title;


-- 4. Show customer and staff emails
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    'customer' AS person_type
FROM customer c
LEFT JOIN staff s
    ON c.email = s.email

UNION ALL

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    s.email,
    'staff' AS person_type
FROM staff s
LEFT JOIN customer c
    ON c.email = s.email
WHERE c.customer_id IS NULL
ORDER BY email;


-- 5. Find the actors in the film 'ACADEMY DINOSAUR'
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
JOIN film f
    ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR'
ORDER BY a.last_name, a.first_name;


-- 6. Show each store and how many staff members work there
SELECT
    s.store_id,
    COUNT(st.staff_id) AS staff_count
FROM store s
LEFT JOIN staff st
    ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY s.store_id;


-- 7. List customers who rented more than 5 films
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 5
ORDER BY rental_count DESC, c.customer_id;

