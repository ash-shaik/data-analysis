/**
  Smoothed moving average metrics provide easier ways to detect trends in the time range.
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

-- Using window function.
SELECT extract('year' FROM p.payment_date) || '-'
    || extract('month' FROM p.payment_date)                                                  AS year_month
     , AVG(p.amount) OVER (ORDER BY payment_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)   as moving_average_amount
     , COUNT(p.amount) OVER (ORDER BY payment_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as num_records
FROM vtrbusic.payment p
;

-- YTD amount
SELECT extract('year' FROM p.payment_date) || '-'
    || extract('month' FROM p.payment_date)                                                                   AS year_month
     , amount
     , SUM(p.amount)
       OVER (PARTITION BY extract('month' FROM p.payment_date) ORDER BY extract('month' FROM p.payment_date)) as ytd_amount
FROM vtrbusic.payment p
;

-- Month Over Month sales

WITH monthy_sales AS (SELECT extract('year' FROM p.payment_date) || '-'
    || extract('month' FROM p.payment_date) AS year_month
                           , SUM(amount)    as amount
                      FROM vtrbusic.payment p
                      GROUP BY extract('year' FROM p.payment_date) || '-'
                                   || extract('month' FROM p.payment_date))

SELECT year_month
     , amount
     , lag(year_month) OVER ( ORDER BY year_month) as prev_month
     , lag(amount) OVER ( ORDER BY year_month)     as prev_amount
FROM monthy_sales
;

-- Percentage Growth of Sales
WITH monthy_sales AS (SELECT extract('year' FROM p.payment_date) || '-'
    || extract('month' FROM p.payment_date) AS year_month
                           , SUM(amount)    as amount
                      FROM vtrbusic.payment p
                      GROUP BY extract('year' FROM p.payment_date) || '-'
                                   || extract('month' FROM p.payment_date))

   , mom_sales AS (SELECT year_month
                        , amount
                        , lag(year_month) OVER ( ORDER BY year_month) as prev_month
                        , lag(amount) OVER ( ORDER BY year_month)     as prev_amount
                   FROM monthy_sales)

SELECT year_month
     , amount
     , (amount / prev_amount - 1) * 100 AS monthly_pct_growth
FROM mom_sales
;