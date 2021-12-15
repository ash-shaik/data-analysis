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

-- Assign a progressive number for each row within the partition.
SELECT post_type
     , ROW_NUMBER(*) over W
from tali_walt.wp_posts
    WINDOW W as (PARTITION by post_type)
order by post_type;

-- To get the first and last value with in the partition.
SELECT post_type
     , ROW_NUMBER() over W
     , post_title
     , FIRST_VALUE(post_title) OVER W
     , LAST_VALUE(post_title) OVER W
FROM tali_walt.wp_posts
    WINDOW W AS (PARTITION BY post_type ORDER BY post_type)
ORDER BY post_type;