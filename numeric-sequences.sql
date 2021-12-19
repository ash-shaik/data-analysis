/*
  Here is a pattern for Generating sequence of numbers , for a smaller upper bound.
  We'll do this by using a fun question from hacker rank.
 */

-- in MySQL cte_max_recursion_depth controls the upper
-- limit of this bound in the query.
WITH RECURSIVE seq AS
                       (SELECT 1 AS value UNION ALL SELECT value + 1 FROM seq WHERE value < 20)
SELECT REPEAT('* ', value)
FROM seq;

-- https://www.hackerrank.com/challenges/print-prime-numbers
-- Use of sub queries. Sub Query when it returns any rows NOT EXISTS evaluates to FALSE.

WITH RECURSIVE seq AS
                       (SELECT 2 AS value UNION ALL SELECT value + 1 FROM seq WHERE value < 1000)
SELECT GROUP_CONCAT(value SEPARATOR '&')
FROM (SELECT value
      FROM seq p
      WHERE NOT EXISTS
          (SELECT value FROM seq d
           WHERE (p.value % d.value) = 0
             AND p.value > d.value)
     ) xx;
