/*
 Here is a pattern to sample a random record without throttling the database.
 Data Source : Mode Analytics, public dataset : tutorial.billboard_top_100_year_end
 */

SELECT id,
       song_name
FROM tutorial.billboard_top_100_year_end TABLESAMPLE BERNOULLI(1)
LIMIT 1;

-- When we are looking for an efficient query, this will still do a table scan.
SELECT id,
       song_name
FROM tutorial.billboard_top_100_year_end
WHERE id >= (
    SELECT FLOOR(random() * (max(id) - min(id) + 1) + min(id))
    FROM tutorial.billboard_top_100_year_end
)
ORDER BY id
LIMIT 1;

-- A better approach could be to use a subquery and JOIN to avoid the table scan.
SELECT id, song_name
FROM tutorial.billboard_top_100_year_end tb1
         JOIN
     (SELECT FLOOR(min(id) + (max(id) - min(id) + 1) * RANDOM()) AS id2
      FROM tutorial.billboard_top_100_year_end) tb2 ON tb1.id = tb2.id2
;