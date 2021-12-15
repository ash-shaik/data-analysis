/*
 Here is a pattern to sample a random record without throttling the database.
 Data Source : Mode Analytics, public dataset : tutorial.billboard_top_100_year_end
 */

SELECT id,
       song_name
FROM tutorial.billboard_top_100_year_end TABLESAMPLE BERNOULLI(1)
LIMIT 1;

SELECT id,
       song_name
FROM tutorial.billboard_top_100_year_end
WHERE id >= (
    SELECT random() * (max(id) - min(id)) + min(id)
    FROM tutorial.billboard_top_100_year_end
)
ORDER BY id
LIMIT 1;

