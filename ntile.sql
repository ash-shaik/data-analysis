/**
  Queries that build /get the Top
  1. Which movies are in top 10%.
  Using NTILE - we divide the records into specified number of ranked buckets.
 */

--Get the basic data we need
SELECT f.film_id, f.title, SUM(p.amount) as sales
FROM vtrbusic.rental r
         JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
         JOIN vtrbusic.film f ON f.film_id = i.film_id
         JOIN vtrbusic.payment p ON p.rental_id = r.rental_id
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Build the percentile, over the records

SELECT f.film_id
     , f.title
     , SUM(p.amount) as                               sales
     , NTILE(1000) OVER (ORDER BY SUM(p.amount) DESC) percentile_rank
     , SUM(SUM(p.amount)) OVER ()                     total_sales

FROM vtrbusic.rental r
         JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
         JOIN vtrbusic.film f ON f.film_id = i.film_id
         JOIN vtrbusic.payment p ON p.rental_id = r.rental_id
GROUP BY 1, 2
ORDER BY 3 DESC
;

-- filter to get the top 10%
SELECT f.film_id
     , f.title
     , SUM(p.amount) as                              sales
     , NTILE(100) OVER (ORDER BY SUM(p.amount) DESC) percentile_rank
     , SUM(SUM(p.amount)) OVER ()                    total_sales

FROM vtrbusic.rental r
         JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
         JOIN vtrbusic.film f ON f.film_id = i.film_id
         JOIN vtrbusic.payment p ON p.rental_id = r.rental_id
GROUP BY 1, 2
ORDER BY 3 DESC
;