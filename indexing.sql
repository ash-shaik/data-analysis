/**
  Indexing - Here the context is to understand change in data (% change in value) with respect
  to a base period.

 */

-- Here is the current sales vs the base period sale amount for one actior
SELECT year_month
     , susan_davis_sales
     , (susan_davis_sales / sd_index_sale_amount - 1) * 100 as percent_from_index
FROM (
         SELECT year_month
              , susan_davis_sales
              , FIRST_VALUE(susan_davis_sales) OVER (ORDER BY year_month) as sd_index_sale_amount
         FROM (
                  SELECT extract('year' FROM p.payment_date) || '-'
                      || extract('month' FROM p.payment_date) AS year_month
                       , ROUND(SUM(p.amount))::int            as susan_davis_sales
                  FROM vtrbusic.payment p
                           JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
                           JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
                           JOIN vtrbusic.film f ON f.film_id = i.film_id
                           JOIN vtrbusic.film_actor fa ON fa.film_id = f.film_id
                           JOIN vtrbusic.actor a ON a.actor_id = fa.actor_id

                  WHERE a.actor_id = 101
                  GROUP BY 1
                  ORDER BY 1) sd) sdi


