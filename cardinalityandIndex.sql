/*
Cardinality

While studying about cardinality, I found the concept explained in a very complicated manner, so I decided to simplify and summarize the key points as much as possible.

To get straight to the point, if the duplication rate is 'low', then the cardinality is considered 'high'. Conversely, if the duplication rate is 'high', then the cardinality is considered 'low'. Cardinality is an indicator that represents the degree of duplication for a specific column across all rows.

Even this explanation might sound too complex. But, from what I have understood, cardinality is not such a difficult concept. The initial confusion about cardinality came from not understanding that it is a 'relative concept'.

For example, a Social Security Number, which does not have duplicate values, can be said to have high cardinality. In contrast, names, which have more duplicates compared to Social Security Numbers, have lower cardinality compared to Social Security Numbers. This emphasis on 'compared to Social Security Numbers' is because cardinality should be understood as a relative concept.

Consider the following table (let's call it the users table):

id	name	location
0	lee	seoul
1	park	pusan
2	choi	seoul
3	park	seoul
4	kim	seoul
5	bae	incheon
6	ahn	seoul
7	lee	seoul
8	lee	seoul
9	kim	seoul

For the id column, since there are no duplicate values across the 10 rows (similar to how a column with unique values like a Social Security Number would be), it is said to have 'high' cardinality. For the name column, since there are 6 distinct values (lee, park, choi, kim, bae, ahn), its cardinality is 'lower than the id column'. For the location column, since there are only 3 distinct values (seoul, pusan, incheon), it has the 'lowest' cardinality.

It's worth noting that having many distinct values means a low rate of duplication.

In terms of distinct values among the columns of the users table, it goes as follows: id (10) > name (6) > location (3). Thus, more distinct values mean lower duplication rate = higher cardinality.

Therefore, cardinality should be understood more as a relative concept than an absolute figure. When indexing, filtering out as much data as possible in the selection process will yield better performance. (The more data selected, the closer it gets to a full scan.) Hence, when indexing multiple columns simultaneously, prioritizing columns with higher cardinality (lower duplication) is advantageous for the indexing strategy.

Let's apply indexes to the users table:
*/

CREATE INDEX idx_location_first ON users(location, name, id);
CREATE INDEX idx_id_first ON users(id, name, location);

/*
Two indexes have been created for the example table: idx_location_first and idx_id_first. Both indexes use all three columns as index columns.

The former index uses the location column as the first index column, as the name suggests, while the latter uses the id column as the first. In other words, the former indexed a column with low cardinality (high duplication) first, and the latter indexed a column with high cardinality (low duplication) first.

What difference does simply changing the order of indexing columns make in practice? Let's understand this through the following query:
*/

SELECT *
FROM users
USE INDEX (idx_location_first)
WHERE id = '0'
AND name = 'lee'
AND location = 'seoul';
/*
The third line uses the "USE INDEX" keyword, which, if not used, would allow the optimizer to automatically select an index. This query explicitly specifies an index for testing both idx_location_first and idx_id_first indexes using the USE INDEX keyword.

Testing with the relatively lower cardinality idx_location_first index first, it prioritizes indexing the location column. Although the query specifies id, name, location in the WHERE clause, because indexing prioritizes the location column, it first filters for values where location is 'seoul', leaving 8 matching records (see the table for why 8 records remain).

Next, it filters for data where the name is 'lee', checking only among the remaining 8 records and leaving 3 matching records. Finally, it searches among the remaining 3 records for the one with id '0'.

Now, consider using the idx_id_first index:
*/

SELECT *
FROM users
USE INDEX (idx_id_first)
WHERE id = '0'
AND name = 'lee'
AND location = 'seoul';

/*
In the case of the idx_id_first index, the id column is indexed first. This means that the index filters out the value where id = '0' from the start, leaving only one data record after the first search. Next, it checks this single remaining data record to see if the name = 'lee'. Lastly, it also checks this one remaining data record to confirm if the location = 'seoul'.

While the number of data records in this example may be small and the difference in performance may not be perceptible, indexing thousands, tens of thousands, or even millions of data records can result in a significant performance difference. Therefore, when selecting indexing columns, considering cardinality is an important factor.

*/