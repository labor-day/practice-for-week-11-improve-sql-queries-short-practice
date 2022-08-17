----------
-- Step 0 - Create a Query
----------
-- Query: Select all cats that have a toy with an id of 5

    -- Your code here
    /*
    SELECT cats.name
    FROM cats JOIN cat_toys ON cats.id = cat_toys.cat_id
    WHERE cat_toys.toy_id = 5;
    */

-- Paste your results below (as a comment):

    /*
    Rachele
    Rodger
    Jamal
    */



----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here
    EXPLAIN QUERY PLAN
        SELECT cats.name
    FROM cats JOIN cat_toys ON cats.id = cat_toys.cat_id
    WHERE cat_toys.toy_id = 5;

-- Paste your results below (as a comment):

/*
SCAN TABLE cat_toys
SEARCH TABLE cats USING INTEGER PRIMARY KEY (rowid=?)
*/


-- What do your results mean?

    -- Was this a SEARCH or SCAN?
    /* The cats table was searched
    because the primary key is part of an index.
    The cat_toys table was scanned because we needed to look
    through every toy_id
    */

    -- What does that mean?
    /* This operation can be improved
    if we can search through the cat_toys table as well
    */

----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here

-- Paste your results below (as a comment):
-- Run Time: real 0.001 user 0.000064 sys 0.000016


----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT cats.name
        FROM cats
        JOIN cat_toys
        ON cats.id = cat_toys.cat_id
        JOIN toys
        ON toys.id = cat_toys.toy_id
        WHERE cat_toys.toy_id = 5;

-- Analyze Query:
    -- Your code here

-- Paste your results below (as a comment):


-- Analyze Results:

    -- Is the new index being applied in this query?


----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here

-- Paste your results below (as a comment):

--SEARCH TABLE toys USING INTEGER PRIMARY KEY (rowid=?)
--SCAN TABLE cat_toys
--SEARCH TABLE cats USING INTEGER PRIMARY KEY (rowid=?)
--Run Time: real 0.000 user 0.000062 sys 0.000015


-- Analyze Results:
    -- Are you still getting the correct query results?
    -- the result are the same

    -- Did the execution time improve (decrease)?
    /* the execution time barely improved
    We still scan through the cat_toys table
    and the time taken to search the other two tables is neglible

    -- Do you see any other opportunities for making this query more efficient?


---------------------------------
-- Notes From Further Exploration
---------------------------------
CREATE INDEX idx_cat_toys_toy_id
ON cat_toys(toy_id);

--SEARCH TABLE cat_toys USING INDEX idx_cat_toys_toy_id (toy_id=?)
--SEARCH TABLE cats USING INTEGER PRIMARY KEY (rowid=?)
Run Time: real 0.000 user 0.000075 sys 0.000000

By creating an index for the toy_id column in the cat_toys
table, we now execute 2 searches and 0 scans
This has significantly increased efficiency
*/
