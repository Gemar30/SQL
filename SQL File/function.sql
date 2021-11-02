/* Function */

SELECT DATE_TRUNC('day', book_date),COUNT(t.ticket_no)/sum(total_amount) AS sales_ratio
FROM bookings b
JOIN tickets t
ON b.book_ref= t.book_ref
GROUP BY 1
ORDER BY 2
LIMIT 5;

SELECT DATE_TRUNC('day', book_date),COUNT(tf.ticket_no)/sum(amount) AS sales_ratio
FROM bookings b
JOIN tickets t
ON b.book_ref= t.book_ref
JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
GROUP BY 1
ORDER BY 2
LIMIT 5;

SELECT s.seat_no, s.fare_conditions, a.model ->> 'en' AS model, AVG (a.range) avg_range
FROM seats s
JOIN aircrafts a
USING (aircraft_code)
GROUP BY 1,2,3

SELECT s.seat_no, s.fare_conditions, a.model ->> 'en' AS model, AVG (a.range) OVER (PARTITION BY model) avg_range
FROM seats s
JOIN aircrafts a
USING (aircraft_code)
GROUP BY 1,2,model, range;


SELECT s.seat_no, s.fare_conditions, a.model ->> 'en' AS model, range,
RANK ()OVER(PARTITION BY s.seat_no ORDER BY a.range DESC) range_rank
FROM seats s
JOIN aircrafts a
USING(aircraft_code)
ORDER BY range_rank;

SELECT s.seat_no, s.fare_conditions, a.model ->> 'en' AS model, range,
NTILE (5) OVER(PARTITION BY model ORDER BY a.range) ranking
FROM seats s
JOIN aircrafts a
USING (aircraft_code);

WITH CTE AS (SELECT DATE_PART('month', book_date) AS month, SUM(total_amount) AS total_sales
FROM bookings 
GROUP BY month
ORDER BY month)

,CTE2 AS (SELECT month, total_sales,
LEAD (total_sales, 1) OVER (ORDER BY month) next_month_total_sales
FROM CTE)

SELECT month, total_sales, next_month_total_sales,
(next_month_total_sales - total_sales) AS sales_variance
FROM CTE2;

SELECT s.seat_no, s.fare_conditions, a.model ->>'en' AS model , range
INTO aircrafts_details
FROM seats s
JOIN aircrafts a
USING (aircraft_code)
LIMIT 5;

SELECT * FROM aircrafts_details;

/*GROUPING SETS() */
SELECT seat_no, fare_conditions, model, AVG(range)
FROM aircrafts_details
GROUP BY GROUPING SETS (1,2,3);

/*ROLLUP () */
SELECT seat_no, fare_conditions, model, AVG(range)
FROM aircrafts_details
GROUP BY ROLLUP (1,2,3);

/*CUBE () */
SELECT seat_no, fare_conditions, model, AVG(range)
FROM aircrafts_details
GROUP BY CUBE (1,2,3);

/*SELECT INTO() */
SELECT * 
INTO newtable IN external_databse
FROM oldtable
WHERE conditions

SELECT tf.ticket_no, tf.fare_conditions, tf.amount, s.seat_no, s.aircraft_code,
a.model ->> 'en' AS model
INTO _50st_flights_info
FROM ticket_flights tf
JOIN seats s
ON tf.fare_conditions = s.fare_conditions
JOIN aircrafts a
ON s.aircraft_code = a.aircraft_code
LIMIT 50;

SELECT * 
FROM _50st_flights_info;

SELECT t.ticket_no, t.passenger_name, t.contact_data, b.total_amount, b.book_date
INTO tickets_info
FROM tickets t
JOIN bookings b
ON t.book_ref = b.book_ref;

/*VIEW() */
CREATE VIEW view_name AS 
SELECT columnName
FROM tableName
WHERE condition

CREATE VIEW aircrafts_eng AS 
SELECT aircraft_code, model ->> 'en' AS model, range
FROM aircrafts;

SELECT *
FROM aircrafts_eng;

CREATE VIEW airports_eng AS
SELECT airport_code, airport_name ->> 'en' AS airport_name, city ->> 'en' AS city, coordinates, timezone
FROM airports;

SELECT *
FROM airports_eng;

/* Count the number of routes laid from the airports?*/
CREATE VIEW cities AS
SELECT  (SELECT city ->> 'en'
		FROM airports
		WHERE airport_code = departure_airport) AS departure_city,
		(SELECT city ->> 'en'
		FROM airports
		WHERE airport_code= arrival_airport) AS arrival_city
FROM flights;

SELECT departure_city, count(*)
FROM cities
GROUP BY departure_city
HAVING departure_city IN (SELECT  city ->>'en' FROM airports)
ORDER BY count DESC;


/* Position */


SELECT POSITION('SQL' IN 'PostgreSQL')

SELECT STRPOS('PostgreSQL', 'SQL') AS substring_position

SELECT STRPOS('Tamer', 'T') AS substring_position,
STRPOS('Tamer', 't') AS substring_position,
STRPOS('Tamer', 'v') AS substring_position


SELECT passenger_name, STRPOS(passenger_name, ' ')
FROM tickets

SELECT passenger_name, REPLACE(passenger_name, ' ', '-')
FROM tickets

SELECT LEFT('Tamer', 1)
SELECT LEFT('Tamer', 2)
SELECT LEFT('Tamer', -1)
SELECT LEFT('Tamer', -2)

SELECT LEFT(passenger_name, 1)
FROM tickets

SELECT LEFT(passenger_name, 2)
FROM tickets

SELECT LEFT(passenger_name, -1)
FROM tickets

SELECT LEFT(passenger_name, -2)
FROM tickets

SELECT RIGHT('Tamer', 1)
SELECT RIGHT('Tamer', 2)
SELECT RIGHT('Tamer', -1)
SELECT RIGHT('Tamer', -2)

SELECT RIGHT(passenger_name, 1)
FROM tickets

SELECT RIGHT(passenger_name, 2)
FROM tickets

SELECT RIGHT(passenger_name, -1)
FROM tickets

SELECT RIGHT(passenger_name, -2)
FROM tickets

SELECT passenger_name,LEFT(passenger_name, 1),
BTRIM(SPLIT_PART(passenger_name,' ', 1)) first_name,
BTRIM(SPLIT_PART(passenger_name,' ',2)) last_name
FROM tickets;

SELECT passenger_name,RIGHT(passenger_name, 1),
BTRIM(SPLIT_PART(passenger_name,' ', 1)) first_name,
BTRIM(SPLIT_PART(passenger_name,' ',2)) last_name
FROM tickets;

SELECT BTRIM(SPLIT_PART(passenger_name,' ',1)) AS first_name,
		BTRIM (SPLIT_PART(passenger_name,' ',2)) AS last_name
INTO passenger_name_divided
FROM tickets;

SELECT * 
FROM passenger_name_divided

SELECT CONCAT(first_name) ||'/'|| (last_name) AS full_passenger_name
FROM passenger_name_divided;

/*1. Suppose our airline marketers want to know how often there are different names among the passengers?
2. Which combinations of first names and last names separately occur most often? What is the ratio of the passengers with such names to the total number of passengers? */

SELECT LEFT(passenger_name, STRPOS(passenger_name, ' ') - 1) AS firstname, COUNT (*)
FROM tickets
GROUP BY 1
ORDER BY 2 DESC;

WITH p AS (SELECT left(passenger_name, position(' ' IN passenger_name)) AS passenger_name FROM tickets)
SELECT passenger_name, round( 100.0 * cnt / sum(cnt) OVER (), 2) AS percent
FROM (SELECT passenger_name,count(*) cnt FROM p GROUP BY passenger_name) t
ORDER BY percent DESC;

