/**
  1. Size of the window
  2. Aggregation function
  3. Grouping / Partitioning
 */

-- 1 month rolling average of sales.
SELECT extract('year' FROM p.payment_date) || '-'
    || extract('month' FROM p.payment_date) AS year_month
     , p.amount
     , AVG(q.amount)                        as moving_average_amount
     , COUNT(q.amount)                      as num_records


FROM vtrbusic.payment p
         JOIN vtrbusic.payment q ON
    q.payment_date BETWEEN p.payment_date - INTERVAL '1 month' AND p.payment_date
GROUP BY 1, 2
;