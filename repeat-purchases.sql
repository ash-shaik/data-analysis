/*
  Given purchases by customers, when we are looking for users with repeat purchases.
  Using the sid91.store_purchases from Mode Analytics, public dataset.
 */

 WITH num_purchases AS (
  SELECT customer_id,DATE(transaction_date) AS tx_date
  FROM sid91.store_purchases
  GROUP BY customer_id, DATE(transaction_date)
)
SELECT
  COUNT(customer_id) AS num_repeat_customers
FROM
  (
    SELECT customer_id
    FROM num_purchases
    GROUP BY customer_id HAVING COUNT(DISTINCT tx_date) > 1
  ) cust_purchases