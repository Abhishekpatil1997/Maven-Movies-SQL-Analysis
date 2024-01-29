use mavenmovies;

/*
1.Retrieve a comprehensive list of staff members, including their names, email addresses, and corresponding store IDs. 
*/ 

SELECT 
	first_name, 
    last_name, 
	email, 
    store_id
FROM staff;

/*
2.Generate separate counts of inventory items available at each of the two Maven Movies store locations.
*/ 

SELECT 
	store_id, 
	COUNT(inventory_id) AS inventory_items
FROM inventory
GROUP BY 
	store_id;

/*
3.Determine the count of active customers for each store location to assess customer engagement
*/

SELECT 
	store_id, 
    COUNT(customer_id) AS active_customers
FROM customer
WHERE active = 1
GROUP BY 
	store_id;

/*
4.Calculate the total count of customer email addresses stored in the database to evaluate data breach liability 
*/

SELECT 
	COUNT(email) AS emails
FROM customer;

/*
5.Assess the diversity of film offerings by providing counts of unique film titles and categories available at each store.
*/

SELECT 
	store_id, 
    COUNT(DISTINCT film_id) AS unique_films
FROM inventory
GROUP BY 
	store_id; 
	
SELECT 
	COUNT(DISTINCT name) AS unique_categories
FROM category;

/*
6.Analyze film replacement costs by determining the least expensive, most expensive, and average replacement costs.
*/

SELECT 
	MIN(replacement_cost) AS least_expensive, 
    MAX(replacement_cost) AS most_expensive, 
    AVG(replacement_cost) AS average_replacement_cost
FROM film;

/*
7.	Implement payment monitoring systems by calculating the average and maximum payment processed by the company.
*/

SELECT
	AVG(amount) AS average_payment, 
    MAX(amount) AS max_payment
FROM payment;

/*
8.	Gain insights into customer behavior by providing a list of customer IDs sorted by rental volume, highlighting high-volume customers.
*/

SELECT 
	customer_id, 
    COUNT(rental_id) AS number_of_rentals
FROM rental
GROUP BY 
	customer_id
ORDER BY 
	COUNT(rental_id) DESC;
    
/* 
9.Extract data on store managers and locations to facilitate in-person visits for potential investors. 
*/ 

SELECT 
	staff.first_name AS manager_first_name, 
    staff.last_name AS manager_last_name,
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id;

	
/*
10.	Compile an inventory list with film details, including ratings, rental rates, and replacement costs
*/

SELECT 
	inventory.store_id, 
    inventory.inventory_id, 
    film.title, 
    film.rating, 
    film.rental_rate, 
    film.replacement_cost
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id;

/* 

11.	Summarize inventory data to understand the distribution of film ratings across stores

*/

SELECT 
	inventory.store_id, 
    film.rating, 
    COUNT(inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY 
	inventory.store_id,
    film.rating
;

/* 

12.	Analyze inventory diversification in terms of replacement costs and film categories.

*/ 

SELECT 
	store_id, 
    category.name AS category, 
	COUNT(inventory.inventory_id) AS films, 
    AVG(film.replacement_cost) AS avg_replacement_cost, 
    SUM(film.replacement_cost) AS total_replacement_cost
    
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN film_category
		ON film.film_id = film_category.film_id
	LEFT JOIN category
		ON category.category_id = film_category.category_id

GROUP BY 
	store_id, 
    category.name
    
ORDER BY 
	SUM(film.replacement_cost) DESC;

/*
13.	Compile customer profiles, including active status and address details, to assess customer demographics.
*/

SELECT 
	customer.first_name, 
    customer.last_name, 
    customer.store_id,
    customer.active, 
    address.address, 
    city.city, 
    country.country

FROM customer
	LEFT JOIN address ON customer.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;


/*
14.	Calculate customer spending and identify high-value customers based on total lifetime rentals and payments.
*/

SELECT 
	customer.first_name, 
    customer.last_name, 
    COUNT(rental.rental_id) AS total_rentals, 
    SUM(payment.amount) AS total_payment_amount

FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
    LEFT JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
	customer.first_name,
    customer.last_name

ORDER BY 
	SUM(payment.amount) DESC
    ;


    
/*
15.	Provide a list of advisors and investors, along with their affiliations and roles

*/

SELECT
	'investor' AS type, 
    first_name, 
    last_name, 
    company_name
FROM investor

UNION 

SELECT 
	'advisor' AS type, 
    first_name, 
    last_name, 
    NULL
FROM advisor;


/*
16.	Evaluate the coverage of films featuring award-winning actors to gauge content diversity.
*/

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END


