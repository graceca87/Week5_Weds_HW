
--1. List all customers who live in Texas (use JOINs)

-- First join address table and customer table
--SELECT c.customer_id, c.first_name, c.last_name, c.address_id, a.district
--FROM customer c
--JOIN address a
--ON c.address_id = a.address_id

-- Now get customers from Texas

SELECT c.customer_id
FROM customer c
JOIN address a
ON c.address_id = a.address_id
WHERE a.district = 'Texas';

-- Answer: customer id's -> 118, 6, 305, 400, 561

------------------------------------------------------------------------------------------------------------
--2. Get all payments above $6.99 with the Customer’s full name

SELECT c.first_name, c.last_name, p.amount
FROM payment p
JOIN customer c
ON c.customer_id = p.customer_id
WHERE p.amount > 6.99
ORDER BY p.amount;

-- Answer: see query results

--------------------------------------------------------------------------------------------------------------
--3. Show all customer names who have made payments over $175 (their total orders combined) (use subqueries)

-- FIRST find ids of custs whose orders (when combined) totaled over $175, 
--SELECT customer_id, SUM(amount)
--FROM payment
--GROUP BY customer_id
--HAVING SUM(amount) > 175;
----
--THEN find cust names
SELECT DISTINCT c.first_name, c.last_name
FROM payment p
JOIN customer c
ON c.customer_id = p.customer_id
WHERE c.customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id 
	HAVING SUM(amount) > 175
	ORDER BY last_name
);
-- Answer: Clara Shaw, Eleanor Hunt, Karl Seal, Marion Snyder, Rhonda Kennedy, Tommy Collazo

--------------------------------------------------------------------------------------------------------------
--4. List all customers that live in Argentina (use the city table) (cust to address to city to country)
--
----Join customer to address and find the city id:
--SELECT c.customer_id, c.first_name, c.last_name, a.address_id, a.city_id 
--FROM customer c
--JOIN address a
--ON c.address_id = a.address_id;
--
----join address to city
--SELECT c.country_id
--FROM address a  
--JOIN city c 
--ON c.city_id = a.city_id;
--
----join city to country
--SELECT c.country_id, country
--FROM city c 
--JOIN country c2 
--ON c.country_id = c2.country_id;
--
----join address to city, then city to country
--SELECT c.city, c.country_id, c2.country
--FROM address a  
--JOIN city c 
--ON c.city_id = a.city_id 
--JOIN country c2 
--ON c.country_id = c2.country_id 
--;
--
---- get address id where country = Argentina
--SELECT c.city, c.country_id, c2.country, a.address_id 
--FROM address a  
--JOIN city c 
--ON c.city_id = a.city_id 
--JOIN country c2 
--ON c.country_id = c2.country_id
--WHERE c2.country = 'Argentina'

-- Now connect those address ids to customer ids
SELECT customer_id, first_name, last_name
FROM customer c 
WHERE address_id IN (
	SELECT a.address_id 
	FROM address a  
	JOIN city c 
	ON c.city_id = a.city_id 
	JOIN country c2 
	ON c.country_id = c2.country_id
	WHERE c2.country = 'Argentina'
);

-- Answer: see query results
--------------------------------------------------------------------------------------------------------------
--5. Which film category has the most movies in it (show with the count). *did IN CLASS OR find the category WITH the LEAST movies

SELECT * 
FROM film_category;

SELECT category_id, COUNT(*)
FROM film_category
GROUP BY category_id 
ORDER BY count(*) DESC;

--Answer: most movies in category 15

-- category with the least movies in it:
SELECT category_id, COUNT(*)
FROM film_category fc 
GROUP BY category_id 
ORDER BY count(*);

-- Answer: least movies is category 12

--------------------------------------------------------------------------------------------------------------
--6. What film had the most actors in it? (show film info)

--SELECT title
--FROM film
--WHERE film_id IN ()

--Find the film id with the most actors:
SELECT film_id, count(*)
FROM film_actor
GROUP BY film_id
ORDER BY count(*) DESC;

--Find the title of that film
SELECT title
FROM film
WHERE film_id IN (
	SELECT count(film_id) AS num_actors 
	FROM film_actor
	GROUP BY film_id
	ORDER BY num_actors DESC);


-- Answer: film id 508 (Airport Pollock)

--------------------------------------------------------------------------------------------------------------
--7. Which actor has been in the least movies?

-- Find the actor id that appears in the least amount of films
SELECT count(actor_id), actor_id 
FROM film_actor
GROUP BY actor_id 
ORDER BY count(*);

-- Actor id 148 is in the least amount of films so we can narrow down our search with that info

-- You can specifically target this actor:
SELECT count(actor_id), actor_id 
FROM film_actor
GROUP BY actor_id 
HAVING actor_id = 148;

-- Now find the actors name in a list by number of films (joining actor with film_actor):
SELECT fa.actor_id, a.first_name, a.last_name
FROM film_actor fa 
JOIN actor a
ON a.actor_id = fa.actor_id
WHERE a.actor_id IN (
	SELECT count(actor_id) AS num_films
	FROM film_actor
	GROUP BY actor_id 
	ORDER BY num_films);

-- And you can find just this one actor's name with this query:
SELECT DISTINCT fa.actor_id, a.first_name, a.last_name
FROM film_actor fa 
JOIN actor a
ON a.actor_id = fa.actor_id
WHERE a.actor_id IN (
	SELECT count(actor_id)
	FROM film_actor
	GROUP BY actor_id 
	HAVING actor_id = 148);

-- Answer: actor id 148 (Viven Bergen)

--------------------------------------------------------------------------------------------------------------
--8. Which country has the most cities?

-- Join city with country:

--SELECT c2.city, c.country
--FROM city c2 
--JOIN country c 
--ON c2.country_id = c.country_id;

-- Find the number of times the country appears:
SELECT c.country, count(*)
FROM city c2 
JOIN country c 
ON c2.country_id = c.country_id
group BY c.country
ORDER BY count DESC;

-- Answer: India

--------------------------------------------------------------------------------------------------------------
--9. List the actors who have been in more than 23 films but less than 26.

--First join actor with film actor

--SELECT *
--FROM actor a 
--JOIN film_actor fa 
--ON a.actor_id = fa.actor_id 

-- Find actor ids with counts between 23 and 26

--SELECT actor_id, count(*)
--FROM film_actor
--GROUP BY actor_id 
--HAVING count(actor_id) BETWEEN 23 AND 26
--ORDER BY count(actor_id);


-- Get the names of those actors
SELECT DISTINCT a.first_name, a.last_name
FROM actor a 
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IN (
	SELECT actor_id
	FROM film_actor
	GROUP BY actor_id 
	HAVING count(actor_id) BETWEEN 23 AND 26
	ORDER BY count(actor_id)
);

-- Answer: see query results
--------------------------------------------------------------------------------------------------------------

