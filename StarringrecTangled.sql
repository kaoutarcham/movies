est=> ALTER TABLE movies5 ADD lexemesStarring tsvector;
ALTER TABLE
test=> UPDATE movies5 SET lexemesStarring = to_tsvector(Starring);
UPDATE 5229
test=> SELECT url FROM movies5 WHERE lexemesStarring @@ to_tsquery('disney');
 url 
-----
(0 rows)

test=> UPDATE movies5 SET rank = ts_rank(lexemesStarring,plainto_tsquery(( SELECT Starring FROM movies5 WHERE url='tangled')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnStarringField2 AS SELECT url, rank FROM movies5 WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
SELECT 10
test=> \copy (SELECT * FROM recommendationsBasedOnStarringField2) to '/home/pi/RSL/top50recommendationsstarring2.csv' WITH csv;
COPY 10
test=> 
# RSL
