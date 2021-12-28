/*
  Analyzing interval since previous orders.
  Source vtrbusic.payment from Mode Analytics

 */

WITH order_hist AS (
    SELECT p.*
         , LAG(p.payment_date) OVER (PARTITION BY p.customer_id ORDER BY payment_date) as previous_order_date
         , ROW_NUMBER() OVER (PARTITION BY p.customer_id ORDER BY payment_date)        as order_rank
    FROM vtrbusic.payment p
)

SELECT order_hist.payment_id
     , order_hist.customer_id
     , order_hist.amount
     , order_hist.payment_date
     , order_hist.previous_order_date
     , (order_hist.payment_date - order_hist.previous_order_date)                          as interval
     , EXTRACT(EPOCH FROM order_hist.payment_date - order_hist.previous_order_date) / 3600 AS hours_since

FROM order_hist
;

/**
  Building Customer 360
 */
-- Returns first 100 rows from vtrbusic.payment


WITH order_hist AS (
    SELECT p.*
         , LAG(p.payment_date) OVER (PARTITION BY p.customer_id ORDER BY payment_date) as previous_order_date
         , ROW_NUMBER() OVER (PARTITION BY p.customer_id ORDER BY payment_date)        as order_rank
         , ROW_NUMBER() OVER (PARTITION BY p.customer_id ORDER BY amount DESC)         as max_amount_rank
         , ROW_NUMBER() OVER (PARTITION BY p.customer_id ORDER BY amount ASC)          as min_amount_rank
    FROM vtrbusic.payment p
)

   , second_order AS (SELECT order_hist.payment_id
                           , order_hist.customer_id
                           , order_hist.amount
                           , order_hist.payment_date
                           , order_hist.previous_order_date
                           , (order_hist.payment_date - order_hist.previous_order_date)                          as interval
                           , EXTRACT(EPOCH FROM order_hist.payment_date - order_hist.previous_order_date) /
                             3600                                                                                AS hours_since
                      FROM order_hist)

SELECT customer_id
     , payment_date
     , (SELECT payment_date
        FROM order_hist
        WHERE order_hist.customer_id = second_order.customer_id
          AND order_hist.order_rank = 1)      as first_order_date
     , (SELECT payment_date
        FROM order_hist
        WHERE order_hist.customer_id = second_order.customer_id
          AND order_hist.max_amount_rank = 1) as max_amount
     , (SELECT payment_date
        FROM order_hist
        WHERE order_hist.customer_id = second_order.customer_id
          AND order_hist.min_amount_rank = 1) as min_amount
     , (SELECT AVG(hours_since)
        FROM second_order s
        WHERE s.customer_id = second_order.customer_id
        GROUP BY s.customer_id)               as avg_time_between_order

     , previous_order_date
FROM second_order
ORDER BY customer_id, second_order.payment_date
;

