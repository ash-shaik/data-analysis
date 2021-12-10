/*
  Creating Pivot tables using CASE statements.
  Pivot tables allow for great way to summarize datasets.

 */
SELECT DATE(c.date) AS order_date,
       SUM(
               CASE
                   WHEN item = 'eggs' THEN ci.quantity * ci.price_per_unit_cents
                   ELSE 0
                   END
           )        AS eggs_sale_amount,
       SUM(
               CASE
                   WHEN item = 'milk' THEN ci.quantity * ci.price_per_unit_cents
                   ELSE 0
                   END
           )        AS milk_sale_amount,
       SUM(
               CASE
                   WHEN item = 'bananas' THEN ci.quantity * ci.price_per_unit_cents
                   ELSE 0
                   END
           )        AS bananas_sale_amount,
       SUM(
               CASE
                   WHEN item = 'cheese' THEN ci.quantity * ci.price_per_unit_cents
                   ELSE 0
                   END
           )        AS cheese_sale_amount,
       SUM(
               CASE
                   WHEN item = 'steak' THEN ci.quantity * ci.price_per_unit_cents
                   ELSE 0
                   END
           )        AS steak_sale_amount
FROM andsylk.checkouts c
         JOIN andsylk.checkout_items ci ON c.cart_id = ci.cart_id
GROUP BY 1
ORDER BY 1;

/*
   Aggregating into arrays and un-nesting to flatten the results.
 */


WITH agg_query AS (
    SELECT company,
           ARRAY_AGG(product_id) AS product_list,
           ARRAY_AGG(members)    AS member_list
    FROM davidbowie.nested_test_data
    GROUP BY company
    ORDER BY company
)
SELECT company,
       UNNEST(product_list) AS product,
       UNNEST(member_list)  AS members
FROM agg_query;