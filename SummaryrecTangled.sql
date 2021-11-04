pi@raspberrypi:~/RSL $ psql test
psql (11.13 (Raspbian 11.13-0+deb10u1))
Type "help" for help.

test=> CREATE TABLE movies5 (
test(> url text,
test(> title text,
test(> ReleaseDate text,
test(> Distributor text,
test(> Starring text,
test(> Summary text,
test(> Director text,
test(> Genre text,
test(> Rating text,
test(> Runtime text,
test(> Userscore text,
test(> Metascore text,
test(> scoreCounts text
test(> );
CREATE TABLE
test=> \copy movies5 FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header;
COPY 5229
test=> SELECT * FROM movies5 where url='tangled';

[1]+  Stopped                 psql test
pi@raspberrypi:~/RSL $ psql test
psql (11.13 (Raspbian 11.13-0+deb10u1))
Type "help" for help.

test=> ALTER TABLE movies5
test-> ADD lexemesSummary tsvector;
ALTER TABLE
test=> UPDATE movies SET lexemesSummary = to_tsvector(Summary);
UPDATE 0
test=> UPDATE movies5 SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229
test=> SELECT url FROM movies5 WHERE lexemesSummary @@to_tsquery('disney');

[2]+  Stopped                 psql test
pi@raspberrypi:~/RSL $ psql test
psql (11.13 (Raspbian 11.13-0+deb10u1))
Type "help" for help.

test=> ALTER TABLE movies5 ADD rank float4;
ALTER TABLE
test=> UPDATE movies5 SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies5 WHERE url='tangled')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url, rank FROM movies5 WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
ERROR:  relation "recommendationsbasedonsummaryfield" already exists
test=> CREATE TABLE recommendationsBasedOnSummaryField2 AS SELECT url, rank FROM movies5 WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendationa
COPY 50
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendations2.csv' WITH csv;
COPY 50
test=> 
