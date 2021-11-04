test=> ALTER TABLE movies5 ADD lexemesTitle tsvector;
ALTER TABLE
test=> UPDATE movies5 SET lexemesTitle = to_tsvector(Title);
UPDATE 5229
test=> SELECT url FROM movies5 WHERE lexemesTitle @@ to_tsquery('disney');
 url 
-----
(0 rows)

test=> UPDATE movies5 SET rank = ts_rank(lexemesTitle,plainto_tsquery((SELECT Title FROM movies5 WHERE url='tangled')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnTitleField2 AS SELECT url, rank FROM movies5 WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
SELECT 1
test=> \copy (SELECT * FROM recommendationsBasedOnTitleField2) to '/home/pi/RSL/top50recommendationstitle2.csv' WITH csv;
COPY 1
test=> 
