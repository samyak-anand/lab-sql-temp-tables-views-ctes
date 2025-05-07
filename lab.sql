/*

Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include:
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

*/


#Creating view

use sakila;

CREATE  OR REPLACE  VIEW rental_summary  AS
SELECT concat(first_name, ' ', last_name) AS 'customer_name',
		c.customer_id,
		c.email
	FROM customer c 
		inner join rental r on c.customer_id = r.customer_id
	GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
        


CREATE TEMPORARY TABLE customer_payment2 AS
SELECT
    rsv.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rsv
JOIN payment p ON rsv.customer_id = p.customer_id
GROUP BY rsv.customer_id;


-- Use CTE to combine rental and payment summary
WITH customer_summary_cte AS (
    SELECT 
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps ON rs.customer_id = cps.customer_id
)

-- Final report query
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;
