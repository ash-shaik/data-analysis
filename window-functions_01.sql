/*
Window functions create aggregates without flattening the data into a single row.
Data Source : Mode Analytics, public dataset : tali_walt.wp_posts
*/
SELECT post_type
     , COUNT(*) OVER (PARTITION BY post_type) total_in_post_type
     , COUNT(*) OVER ()                       total_posts
FROM tali_walt.wp_posts
ORDER BY post_type;

-- To get distinct post_types and their corresponding counts.
SELECT DISTINCT post_type
              , COUNT(*) OVER (PARTITION BY post_type) total_in_post_type
              , COUNT(*) OVER ()                       total_posts
FROM tali_walt.wp_posts
ORDER BY post_type;

-- You could also define an alias for window frame

SELECT DISTINCT post_type
              , COUNT(*) OVER W1 total_in_post_type
              , COUNT(*) OVER W2 total_posts
FROM tali_walt.wp_posts
    WINDOW W1 as (PARTITION by post_type), W2 as ()
ORDER BY post_type;