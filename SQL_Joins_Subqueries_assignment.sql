--1
SELECT customer.address_id, customer_id, first_name, last_name 
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
WHERE district ILIKE 'texas'
GROUP BY customer.address_id, customer_id
ORDER BY last_name ASC; 

--2
SELECT last_name, first_name, amount 
FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE amount >= 6.99 
GROUP BY last_name, first_name, amount
ORDER BY last_name ASC;

--3
SELECT last_name, first_name, amount
FROM (
    SELECT last_name, first_name, amount 
    FROM customer
    LEFT JOIN payment ON customer.customer_id = payment.customer_id
    WHERE amount >= 6.99 
    GROUP BY last_name, first_name, amount
    ORDER BY last_name ASC
) AS six_nienty_nine_payment_customers
WHERE amount > 175
GROUP BY last_name, first_name, amount
ORDER BY last_name ASC;

--4
SELECT last_name, first_name, customer_id
FROM customer
FULL JOIN address ON customer.address_id = address.address_id
FULL JOIN city ON address.city_id = city.city_id
FULL JOIN country ON city.country_id = country.country_id
WHERE country ILIKE 'nepal'
GROUP BY customer_id, last_name, first_name
ORDER BY last_name ASC;

--5
-- Tried to combine payment and rental tables and count rental id_transactions by staff_id repeated in both tables only once
SELECT staff.staff_id, staff.first_name, staff.last_name, count(*) AS transaction_count
FROM staff
JOIN (SELECT staff_id, rental_id FROM payment
     UNION
     SELECT staff_id, rental_id FROM rental
) AS combined_data
ON staff.staff_id = combined_data.staff_id
GROUP BY staff.staff_id, staff.first_name, staff.last_name
ORDER BY transaction_count DESC;

--6
SELECT rating, count(rating)
FROM inventory
LEFT JOIN film ON inventory.film_id = film.film_id
GROUP BY rating 
ORDER BY count(rating) DESC 

--7
SELECT customer.customer_id, last_name, first_name, pmt_count 
FROM customer
RIGHT JOIN (
    SELECT DISTINCT customer_id, count(amount) AS pmt_count
    FROM payment
    WHERE amount > 6.99
    GROUP BY payment.customer_id) AS paying_custs
ON customer.customer_id = paying_custs.customer_id
ORDER BY pmt_count DESC 

--8
--Final question assuming you want me to create a function
CREATE OR REPLACE FUNCTION calc_free_rental_count()
RETURNS INTEGER AS
$$
DECLARE 
    x INTEGER;
    y INTEGER;
    RESULT INTEGER;
BEGIN 
    --Query to fetch total rental count and assign into x
    SELECT count(*) INTO x
    FROM payment
    LEFT JOIN rental ON payment.rental_id = rental.rental_id
    LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id;
    --Query to fetch rental counts greater than zero and assign into y
    SELECT count(*) INTO y
    FROM payment
    LEFT JOIN rental ON payment.rental_id = rental.rental_id
    LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
    WHERE amount > 0;
    --Calculate the difference between total and paid amount rentals
    RESULT := x - y;
    
    --Return the result
    RETURN RESULT;
END;
$$
LANGUAGE plpgsql;

SELECT calc_free_rental_count();

    





