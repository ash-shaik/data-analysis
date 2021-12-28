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

