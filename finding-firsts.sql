/**
   When we want to get details of the first event.
   Here we are using the vtrbusic.payment public dataset.
 **/

-- Using Self join

SELECT po.customer_id, payment_date, SUM(amount) AS first_order_amount
FROM vtrbusic.payment p
         JOIN
     (SELECT customer_id, min(payment_date) as first_order
      FROM vtrbusic.payment
      GROUP BY customer_id) po ON po.first_order = p.payment_date
GROUP BY po.customer_id, payment_date
;


