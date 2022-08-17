----------
-- Step 0 - Create a Query
----------
-- Query: Find a count of `toys` records that have a price greater than
    -- 55 and belong to a cat that has the color "Olive".

    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT COUNT(*)
    FROM toys JOIN cat_toys
    ON toys.id = cat_toys.toy_id
    JOIN cats ON cats.id = cat_toys.cat_id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
-- 215



----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here

-- Paste your results below (as a comment):
/*
|--SCAN TABLE cat_toys
|--SEARCH TABLE toys USING INTEGER PRIMARY KEY (rowid=?)
 --SEARCH TABLE cats USING INTEGER PRIMARY KEY (rowid=?)
*/

-- What do your results mean?

    -- Was this a SEARCH or SCAN?
    -- We conduct 2 searches and a scan

    -- What does that mean?
    -- efficiency can be improved by creating indexes



----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here

-- Paste your results below (as a comment):
-- Run Time: real 0.004 user 0.003746 sys 0.000749


----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
    CREATE INDEX idx_cat_toys_cat_id_toy_id
    ON cat_toys(toy_id, cat_id);

-- Analyze Query:
    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT COUNT(*)
    FROM toys JOIN cat_toys
    ON toys.id = cat_toys.toy_id
    JOIN cats ON cats.id = cat_toys.cat_id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
--QUERY PLAN
--SCAN TABLE cat_toys
--SEARCH TABLE toys USING INTEGER PRIMARY KEY (rowid=?)
--SEARCH TABLE cats USING INTEGER PRIMARY KEY (rowid=?)
--Run Time: real 0.004 user 0.000000 sys 0.004121


-- Analyze Results:

    -- Is the new index being applied in this query?
    -- The new index is not used


----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here

-- Paste your results below (as a comment):


-- Analyze Results:
    -- Are you still getting the correct query results?


    -- Did the execution time improve (decrease)?


    -- Do you see any other opportunities for making this query more efficient?



---------------------------------
-- Notes From Further Exploration
---------------------------------

-- creates indexes for price and name
CREATE INDEX toys_price ON toys(price);
CREATE INDEX cats_name ON cats(name);

--subqueries for use in outer query
SELECT *
FROM toys
WHERE toys.price > 55

SELECT *
FROM cats
WHERE cats.name = 'Olive'

EXPLAIN QUERY PLAN
SELECT COUNT(cat_toys.id)
FROM cat_toys
WHERE cat_toys.toy_id IN (SELECT toys.id FROM toys WHERE toys.price > 55)
    AND cat_toys.cat_id IN (SELECT cats.id FROM cats WHERE cats.name = 'Olive');

--QUERY PLAN
--SEARCH TABLE cat_toys USING COVERING INDEX idx_cat_toys_cat_id_toy_id (toy_id=? AND cat_id=?)
--LIST SUBQUERY 1
    --SEARCH TABLE toys USING COVERING INDEX toys_price (price>?)
--LIST SUBQUERY 2
    --SEARCH TABLE cats USING COVERING INDEX cats_name (name=?)
-- Run Time: real 0.003 user 0.001997 sys 0.000544
-- now search through all tables, significantly increasing efficiency
