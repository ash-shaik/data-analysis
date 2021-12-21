/**
  When we want order based metric, say per customer , their order amounts
  - first
  - first week
  - first 2 weeks
  - all time
  Each customer's date is going to be different, so this is when a correlated subquery come in handy.
  These can be run on the vtrbusic.payment and other public dataset on Mode Analytics.
 */

WITH customer_tx AS
         (SELECT customer_id, first_payment_date
          FROM (
                   SELECT p.customer_id
                        , payment_date as first_payment_date
                        , row_number() OVER (PARTITION BY p.customer_id ORDER BY payment_date) rn
                   FROM vtrbusic.payment p) t
          WHERE rn = 1)

SELECT customer_tx.*
     , (SELECT SUM(p2.amount)
        FROM vtrbusic.payment p2
        WHERE p2.customer_id = customer_tx.customer_id
          AND p2.payment_date BETWEEN
            customer_tx.first_payment_date AND
            customer_tx.first_payment_date + INTERVAL '7 days')  AS first_weeks_sales

     , (SELECT SUM(p2.amount)
        FROM vtrbusic.payment p2
        WHERE p2.customer_id = customer_tx.customer_id
          AND p2.payment_date BETWEEN
            customer_tx.first_payment_date AND
            customer_tx.first_payment_date + INTERVAL '14 days') AS first_2week_sales

     , (SELECT SUM(p2.amount)
        FROM vtrbusic.payment p2
        WHERE p2.customer_id = customer_tx.customer_id)                                              AS LTV


FROM customer_tx