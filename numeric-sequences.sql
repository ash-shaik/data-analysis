/*
  Here is a pattern for Generating sequence of numbers , for a smaller upper bound.
  We'll do this by using a fun question from hacker rank.
  https://www.hackerrank.com/challenges/draw-the-triangle-2

 */

-- in MySQL cte_max_recursion_depth controls the upper limit of this bound in the query.
WITH RECURSIVE seq AS
                       (SELECT 1 AS value UNION ALL SELECT value + 1 FROM seq WHERE value < 20)
SELECT REPEAT('* ', value)
FROM seq;