/**
  * Queries here some time series analysis on the rental payments data.
  * Percentage of totals.
  vtrbusic.payments

 */

-- Gap analysis between sales of two actors along the years.
SELECT year_month
     , (susan_davis_sales - gina_degeneres_sales)           AS gap1way
     , (gina_degeneres_sales - susan_davis_sales)           AS gaptheotherway
     , susan_davis_sales / gina_degeneres_sales             AS sales_ratio
     , (susan_davis_sales / gina_degeneres_sales - 1) * 100 as susan_pct_of_gina
FROM (
         SELECT extract('year' FROM p.payment_date) || '-'
             || extract('month' FROM p.payment_date) AS year_month
              , SUM(CASE
                        WHEN (a.first_name || ' ' || a.last_name) = 'Susan Davis' THEN p.amount
             END)                                    as susan_davis_sales

              , SUM(CASE
                        WHEN (a.first_name || ' ' || a.last_name) = 'Gina Degeneres' THEN p.amount
             END)                                    as gina_degeneres_sales

         FROM vtrbusic.payment p

                  JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
                  JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
                  JOIN vtrbusic.film f ON f.film_id = i.film_id
                  JOIN vtrbusic.film_actor fa ON fa.film_id = f.film_id
                  JOIN vtrbusic.actor a ON a.actor_id = fa.actor_id


         GROUP BY 1
         ORDER BY 1) gap
;

-- Sales as a percentage of total sales
SELECT year_month
     , (susan_davis_sales - gina_degeneres_sales)           AS gap1way
     , (gina_degeneres_sales - susan_davis_sales)           AS gaptheotherway
     , susan_davis_sales / gina_degeneres_sales             AS sales_ratio
     , (susan_davis_sales / gina_degeneres_sales - 1) * 100 as susan_pct_of_gina
     , susan_davis_sales * 100 / total_sales                AS susan_sales_pct_of_total_sales
     , gina_degeneres_sales * 100 / total_sales             AS ginan_sales_pct_of_total_sales
FROM (
         SELECT extract('year' FROM p.payment_date) || '-'
             || extract('month' FROM p.payment_date) AS year_month
              , SUM(CASE
                        WHEN (a.first_name || ' ' || a.last_name) = 'Susan Davis' THEN p.amount
             END)                                    as susan_davis_sales

              , SUM(CASE
                        WHEN (a.first_name || ' ' || a.last_name) = 'Gina Degeneres' THEN p.amount
             END)                                    as gina_degeneres_sales
              , SUM(p2.amount)                       as total_sales
         FROM vtrbusic.payment p

                  JOIN vtrbusic.payment p2 ON p.payment_date = p2.payment_date

                  JOIN vtrbusic.rental r ON p.rental_id = r.rental_id
                  JOIN vtrbusic.inventory i ON i.inventory_id = r.inventory_id
                  JOIN vtrbusic.film f ON f.film_id = i.film_id
                  JOIN vtrbusic.film_actor fa ON fa.film_id = f.film_id
                  JOIN vtrbusic.actor a ON a.actor_id = fa.actor_id


         GROUP BY 1
         ORDER BY 1) gap
;
