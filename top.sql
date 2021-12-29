/**
  1. Top 5 actors by gross amount
  2. Customers who rented movies of the top 5 actors
  Reference - Packt Book, Advanced Applied SQL for Business Intelligence and Analytics
  is a great reference for these queries.

 */

-- Top 5 Actors
WITH base_table AS (
    SELECT a.first_name || ' ' || a.last_name actor_actress
         , a.actor_id
         , p.amount
         , r.inventory_id
         , f.film_id
    FROM vtrbusic.payment p
             JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
             JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
             JOIN vtrbusic.film f ON f.film_id = i.film_id
             JOIN vtrbusic.film_actor fa ON fa.film_id = f.film_id
             JOIN vtrbusic.actor a ON a.actor_id = fa.actor_id
)
   , top5 AS
    (SELECT bt.actor_id, bt.actor_actress, SUM(bt.amount)
     FROM base_table bt
     GROUP BY 1, 2
     ORDER BY 3 DESC
     LIMIT 5)

SELECT *
FROM top5
;

-- Num Customers who rented movies of the top 5 actors.
WITH base_table AS (
    SELECT a.first_name || ' ' || a.last_name actor_actress
         , a.actor_id
         , p.amount
         , r.inventory_id
         , f.film_id
    FROM vtrbusic.payment p
             JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
             JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
             JOIN vtrbusic.film f ON f.film_id = i.film_id
             JOIN vtrbusic.film_actor fa ON fa.film_id = f.film_id
             JOIN vtrbusic.actor a ON a.actor_id = fa.actor_id
)
   , top5 AS
    (SELECT bt.actor_id, bt.actor_actress, SUM(bt.amount)
     FROM base_table bt
     GROUP BY 1, 2
     ORDER BY 3 DESC
     LIMIT 5)
   , top_movies AS (
    SELECT distinct fa.film_id
    FROM vtrbusic.film_actor fa
    WHERE fa.actor_id IN (
        SELECT actor_id
        FROM top5)
)

SELECT COUNT(distinct customer_id)
FROM (
         SELECT p.customer_id, p.amount, i.inventory_id, f.film_id
         FROM vtrbusic.payment p
                  JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
                  JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
                  JOIN vtrbusic.film f ON f.film_id = i.film_id
         WHERE f.film_id IN (select film_id from top_movies)
     ) t



