/*

This snippet is for comparing GLOBAL STATUS variables during 2 tests.

Let's say we had one test yesterday (beginning snapshot ID is 141, final one = 151)
and one more test today (snapshot ID   begin: 300, end: 310)

We would like to compare changes between two tests

*/

use wr;
-- 1. identify snapshot ID for our tests
SELECT * FROM wrsnapshot order by snapId desc

-- 2. prepare data (data is written into tmpRepGlobal_Status)
call spRepGlobal_Status_Clear();
call spRepGlobal_Status_Add(@astartId := 141, @afinishId := 151); 
call spRepGlobal_Status_Add(@astartId := 300, @afinishId := 310); 

-- ------------------------------------------
-- Comparing SQL, showing variable deltas (it's applicable for numberic variables, not boolean or string ones)
SELECT a.snapIdBeg, a.variable_name
     , deltaValue, minimumValue, maximumValue
  FROM tmpRepGlobal_Status a
 order by variable_name
        , snapIdBeg 

