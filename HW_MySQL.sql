USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SHOW TABLES;
SELECT first_name, last_name FROM actor;
SELECT first_name, last_name FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, " ", last_name)) AS "Actor Name" FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query
-- would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT  * FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT * FROM actor
WHERE last_name LIKE "%LI%";
ORDER BY firt_name, last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ("Afganistan", "Bangladesh", "China");

-- 3a
ALTER TABLE actor
	ADD COLUMN description BLOB;
    
-- 3b
ALTER TABLE actor
	ADD COLUMN description;
    
-- 4a
SELECT last_name, COUNT(last_name)
FROM actor GROUP BY last_name;

-- 4b
SELECT
	last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING
	COUNT(last_name) >= 2;

-- 4c
UPDATE actor
SET first_name = "HARPO"
WHERE first_name ="GROUCHO" AND last_name = "WILLIAMS";

-- 4D
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

SELECT * FROM actor WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

SHOW CREATE TABLE address;
CREATE TABLE IF NOT EXISTS address (
'address_id' smallint(5) unsigned NOT NULL AUTO_INCREMENT,
'address' VARCHAR(50) NOT NULL,
'address2' VARCHAR(50) DEFAULT NULL,
'distric' VARCHAR(20) NOT NULL,
'city_id' smallint(5) unsigned NOT NULL,
'postal_code' VARCHAR(10) DEFAULT NULL,
'phone' VARCHAR(20) NOT NULL,
'location' geometry NOT NULL,
'last update' timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT TIMESTAMP
PRIMARY KEY (address_id),
KEY 'idx_fk_city_id' ('city_id'),
SPATIAL KEY 'idx_location' ('location'),
CONSTRAIN 'fk_address_city' FOREIGN KEY ('city_id') REFERENCES 'city' ('city_id') ON UPDATE CASCADE
ENGINE=InnoDB AUTO INCREMENT=606 DEFAULT CHARSET=uft8;

-- 6a
SELECT
	staff.first_name, staff.last_name, address.address
FROM
	address
		INNER JOIN
			staff on address.address_id = staff.address_id
            
-- 6b
SELECT 
	staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
AS "Amount Rung Up in August", payment.payment_date, COUNT(staff.first_name), COUNT(staff.last_name)
FROM
	staff
		INNER JOIN
			payment on staff.staff_id = payment.staff_id
WHERE
	payment_date LIKE "2005-08%"
GROUP BY
	staff.staff_id;
    
    
-- 6c
SELECT
	film.title, COUNT(film_actor.actor_id) AS "Total Actors Listed"
FROM
	film_actor
		INNER JOIN
			film on film_actor.film_id = film.film_id
GROUP BY
			film.title;
            
            
-- 6d
SELECT
	film.title, COUNT(film.title) AS "Number of copies"
FROM
	film	
		INNER JOIN
			inventory i on film.film_id = i.film_id
WHERE
	film.title LIKE "Hunchnack Impossible";
    
-- 6e
SELECT
	customer.last_name, customer.first_name, SUM(payment.amount) AS "Total number paid"
FROM
	payment
		INNER JOIN
			customer ON payment.customer_id = customer.customer_id
GROUP BY
	payment.customer_id
ORDER BY customer.last_name;


-- 7a
SELECT
	title
FROM
	film
WHERE language_id IN
	(SELECT
		language_id
     FROM language
     WHERE name = "English"
		AND title LIKE "K%" OR "Q%"
        
-- 7b
SELECT
		first_name, last_name
FROM
	actor
WHERE actor_id IN
		(SELECT
				actor_id
		FROM film_actor
        WHERE film_id IN
				(SELECT
						film_id
				FROM film
                WHERE title = "Alone Trip"));

-- 7c
SELECT
	first_name, last_name, email, country
FROM
	customer	
		INNER JOIN
			customer_list ON customer.customer_id = customer_list.ID
WHERE country = "Canada";

-- 7d
SELECT
	title, category
FROM
	film_list
WHERE category = "Family";

-- 7e
SELECT
	title, COUNT(title) AS "rent_count"
FROM
	film	
		INNER JOIN
			inventory on film.film_id = inventory.film_id
		INNER JOIN
			rental on inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY
		rent_count DESC;
        
-- 7f
SELECT
	storme, total_sales
FROM
	sales_by_store;
	
-- 7g
SELECT
	store.store_id, city.city, country.country
FROM
	store
		INNER JOIN
			address ON store.address_id = address.address_id
		INNER JOIN
			city ON address.city_id = city.city_id
        INNER JOIN
			country ON city.country_id = country.country_id;
            
-- 7h
SELECT * 
FROM
	sales_by_film_category order by total_sales DESC LIMIT 5;
    
-- 8a
CREATE VIEW top_five_genres AS
	SELECT *
    FROM
		sales_by_film_category
	ORDER BY total_sales desc limit 5;
    
    
-- 8b
SELECT * 
FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;








    
    





        
        
    


  
  
    
	




        























            
            
            

    
    


    
    
    


        



    



    




    
            
    

    


















   












    
    




