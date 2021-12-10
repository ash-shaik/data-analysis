 /*
   Date dimension - Table with one row per day/dates with other attributes
   such as, day of the week, month name etc..
   Useful when we want to analyze metrics on all days.
   Using ncharlton.q1_subscriptions from Mode Analytics, public dataset.
   */
  -- CREATE TABLE dates AS
  WITH dates AS (
    SELECT
      date,
      CAST(to_char(date, 'yyyymmdd') AS int) AS date_key,
      date_part('year', date) AS year,
      date_part('day', date)  AS day_of_month,
      date_part('doy', date)  AS day_of_year,
      date_part('dow', date)  AS day_of_week,
      trim(to_char(date, 'Dy')) AS day_name,
      date_part('week', date)  AS week_number,
      to_char(date, 'W') AS week_of_month,
      date_trunc('week', date) AS start_of_the_week,
      date_part('month', date) AS month_number,
      trim(to_char(date, 'Mon')) AS monthname,
      date_trunc('month', date) AS first_day_of_month,
      date_trunc('month', date) + INTERVAL '1 month' - INTERVAL '1 day' AS last_day_of_month

    FROM
      generate_series(
        TO_DATE('2020-01-01', 'YYYY-MM-DD'),
        TO_DATE('2025-12-31', 'YYYY-MM-DD'),
        '1 day'
      ) AS date
  )
SELECT
  DATE(d.date),
  s.subscriber_id,
  s.subscription_start_date,
  s.monthly_recurring_revenue
FROM
  dates d
  LEFT JOIN ncharlton.q1_subscriptions s ON DATE(d.date) BETWEEN DATE(s.subscription_start_date)
  AND DATE(s.subscription_start_date) + INTERVAL '11 months';