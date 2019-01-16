
-- 1a. Display the first and last names of all actors from the table `actor`.
select first_name,last_name 
from  actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select upper(concat(first_name,' ',last_name)) as Actor_name
from  actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from  actor
where first_name like '%Joe%';
-- 2b. Find all actors whose last name contain the letters `GEN`:
select first_name, last_name
from  actor
where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select first_name, last_name
from  actor
where last_name like '%LI%'
order by first_name, last_name asc;
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country
from country
 where country in('Afghanistan','Bangladesh','China');
/* 3a. You want to keep a description of each actor. You dont think you will be performing queries on a description, so create a column in the table `actor` 
named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).*/

-- adding description with BLOB datatype 
ALTER TABLE actor
ADD description LONGBLOB;

-- updating description value into the added column in actor table
SET SQL_SAFE_UPDATES=0;
UPDATE actor a
INNER JOIN    film_actor fa ON fa.actor_id = a.actor_id 
Inner JOIN 	film_text ft on ft.film_id = fa.film_id
SET a.description = ft.description    
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE  actor 
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT  LAST_NAME,COUNT(*) AS CNT
FROM ACTOR 
GROUP BY LAST_NAME 
HAVING COUNT(*) > 1;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT  LAST_NAME,count(*)
FROM ACTOR 
group by LAST_NAME
HAVING COUNT(*) >=2;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE ACTOR
SET FIRST_NAME = 'HARPO'
WHERE FIRST_NAME = 'GROUCHO'
and LAST_NAME = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE ACTOR
SET FIRST_NAME = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO'
and LAST_NAME = 'WILLIAMS';

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- data is in a separate script named address_data.sql


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name,last_name,ADDRESS.ADDRESS
FROM ADDRESS 
INNER JOIN STAFF ON STAFF.address_id = ADDRESS.address_id

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT STAFF.FIRST_NAME,STAFF.LAST_NAME,SUM(PAYMENT.AMOUNT) AS TOTAL_AMOUNT
FROM STAFF 
INNER JOIN PAYMENT ON STAFF.staff_id = PAYMENT.STAFF_ID
GROUP BY STAFF.FIRST_NAME,STAFF.LAST_NAME
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT  FILM.TITLE,COUNT(*)
FROM film_actor
INNER JOIN FILM ON FILM_ACTOR.FILM_ID = FILM.FILM_ID
GROUP BY  FILM.TITLE
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT COUNT(*) AS FILM_COPIES
FROM INVENTORY 
WHERE FILM_ID IN (SELECT FILM_ID FROM FILM WHERE TITLE = 'Hunchback Impossible' )


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT FIRST_NAME,LAST_NAME, sum(payment.amount) as total_paid
FROM CUSTOMER
INNER JOIN PAYMENT ON  CUSTOMER.customer_id = payment.customer_id
group by FIRST_NAME,LAST_NAME
 -- ![Total amount paid](Images/total_payment.png)

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies 
starting with the letters `K` and `Q` whose language is English.*/

SELECT TITLE
FROM FILM 
where (TITLE like 'K%'OR TITLE LIKE 'Q%')
AND LANGUAGE_ID IN (SELECT LANGUAGE_ID FROM language WHERE NAME = 'English')

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT FIRST_NAME,LAST_NAME 
FROM ACTOR
WHERE ACTOR_ID IN (SELECT A.ACTOR_ID FROM FILM_ACTOR A INNER JOIN FILM B ON A.FILM_ID = B.FILM_ID WHERE B.TITLE = 'Alone Trip')

/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/

SELECT FIRST_NAME, LAST_NAME,EMAIL,COUNTRY
FROM CUSTOMER 
left JOIN ADDRESS ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
left JOIN COUNTRY ON ADDRESS.ADDRESS_ID = COUNTRY.COUNTRY_ID
WHERE COUNTRY = 'Canada'


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

SELECT FILM.TITLE, CATEGORY.NAME
FROM FILM 
INNER JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID  
INNER JOIN CATEGORY ON FILM_CATEGORY.CATEGORY_ID = CATEGORY.CATEGORY_ID and name like '%Family%'

-- 7e. Display the most frequently rented movies in descending order.
SELECT FILM.TITLE,SUM(PAYMENT.AMOUNT) AS AMOUNT
FROM RENTAL  
INNER JOIN PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id  
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY FILM.TITLE
ORDER BY SUM(PAYMENT.AMOUNT) DESC

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select STORE.STORE_ID,concat('$',cast(SUM(PAYMENT.AMOUNT) as char)) AS AMOUNT
from STORE 
INNER JOIN STAFF ON STAFF.STORE_ID = STORE.STORE_ID
INNER JOIN PAYMENT ON STAFF.STAFF_ID = PAYMENT.STAFF_ID
GROUP BY STORE.STORE_ID

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT STORE.STORE_ID, CITY.CITY,COUNTRY.COUNTRY
FROM STORE 
INNER JOIN ADDRESS ON ADDRESS.ADDRESS_ID = STORE.ADDRESS_ID 
INNER JOIN CITY ON CITY.CITY_ID = ADDRESS.CITY_ID
INNER JOIN COUNTRY ON CITY.COUNTRY_ID = COUNTRY.COUNTRY_ID


-- 7h. List the top five genres in gross revenue in descending order. (----Hint----: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT CATEGORY.NAME,SUM(PAYMENT.AMOUNT) AS REVENUE 
FROM CATEGORY 
INNER JOIN FILM_CATEGORY ON CATEGORY.CATEGORY_ID = FILM_CATEGORY.CATEGORY_ID
INNER JOIN FILM ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID 
INNER JOIN INVENTORY ON INVENTORY.FILM_ID = FILM.FILM_ID
INNER JOIN RENTAL ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN PAYMENT ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
GROUP BY CATEGORY.NAME
ORDER BY SUM(PAYMENT.AMOUNT) DESC
LIMIT 5;


/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/
CREATE VIEW TOP_GENRES AS
SELECT CATEGORY.NAME,SUM(PAYMENT.AMOUNT) AS REVENUE 
FROM CATEGORY 
INNER JOIN FILM_CATEGORY ON CATEGORY.CATEGORY_ID = FILM_CATEGORY.CATEGORY_ID
INNER JOIN FILM ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID 
INNER JOIN INVENTORY ON INVENTORY.FILM_ID = FILM.FILM_ID
INNER JOIN RENTAL ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN PAYMENT ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
GROUP BY CATEGORY.NAME
ORDER BY SUM(PAYMENT.AMOUNT) DESC
LIMIT 5;


-- 8b. How would you display the view that you created in 8a?
SELECT * FROM TOP_GENRES;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW TOP_GENRES;