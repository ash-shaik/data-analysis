/**
   When we want to get details of the first event.
   Here we are using the vtrbusic.payment public dataset.
 **/

-- Using Self join

SELECT po.customer_id
     , payment_date AS first_order_date
     , SUM(amount)  AS first_order_amount
FROM vtrbusic.payment p
         JOIN
     (SELECT customer_id, min(payment_date) as first_order
      FROM vtrbusic.payment
      GROUP BY customer_id) po ON po.first_order = p.payment_date
GROUP BY po.customer_id, payment_date
;


-- Using window functions
SELECT customer_id, payment_date as first_order_date, first_order_amount
FROM (
         SELECT customer_id
              , payment_date
              , amount                                                             AS first_order_amount
              , ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS rn
         FROM vtrbusic.payment p) po
WHERE rn = 1

-- using CTE
WITH fot AS (SELECT customer_id
                  , payment_date
                  , amount AS first_order_amount
                  , ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS rn
             FROM vtrbusic.payment)

SELECT customer_id, payment_date as first_order_date FROM fot
WHERE rn = 1;