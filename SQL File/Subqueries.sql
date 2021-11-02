SELECT ai.city ->> 'en', ai.airport_code, ai.airport_name
FROM(
SELECT city, count (*)
FROM airports 
GROUP BY city
HAVING count(*) > 1
) AS q
JOIN airports as ai
ON q.city = ai.city
ORDER BY ai.city, ai.airport_name;

SELECT count(*)
FROM (SELECT DISTINCT city FROM airports) AS a1
JOIN (SELECT DISTINCT city FROM airports) AS a2
ON a1.city <> a2.city;

SELECT f.flight_no, f.departure_airport AS d_airport, f.arrival_airport AS a_airport,
		(SELECT city ->> 'en' FROM airports WHERE airport_code = f.departure_airport) AS d_city,
		(SELECT DISTINCT city ->> 'en' FROM airports WHERE airport_code = f.arrival_airport) AS a_city
FROM flights f
WHERE f.status ='Departed';


/* Exam */
SELECT tt.bookings_no, count(*) passengers_no
FROM (SELECT t.book_ref, count(*) bookings_no
	  FROM tickets t
	  GROUP BY t.book_ref) tt 
GROUP BY tt.bookings_no
ORDER BY tt.bookings_no;


SELECT passenger_name, round(100.0 * cnt/sum(cnt) OVER(),2) AS percent
FROM (SELECT passenger_name, count(*) cnt FROM tickets
	 GROUP BY passenger_name) sub 
ORDER BY percent DESC;

/*1. What are the maximum and minimum ticket prices in all directions?
2. Get a list of airports in cities with more than one airport ?
3. What will be the total number of different routes that are theoretically can be laid between all cities?
*/

SELECT(SELECT city ->> 'en'
	  FROM airports
	  WHERE airport_code = f.departure_airport) AS departure_city,
	  (SELECT city ->>'en' 
	  FROM airports
	  WHERE airport_code = f.arrival_airport) AS arrival_city,
	  MAX(tf.amount), MIN(tf.amount)
	  FROM flights f
	  JOIN ticket_flights tf
	  ON f.flight_id = tf.flight_id
	  GROUP BY 1,2
	  ORDER BY 1,2;


SELECT aa.city ->>'en' AS city, aa.airport_code, aa.airport_name ->> 'en' AS airport
FROM (SELECT city, count(*) FROM airports 
	 GROUP BY city 
	 HAVING count(*) > 1) AS a JOIN airports AS aa ON a.city= aa.city
ORDER BY aa.city, aa.airport_name;

SELECT count(*)
FROM (SELECT DISTINCT city 
	 FROM airports) AS a1
	 JOIN (SELECT DISTINCT city
		  FROM airports) AS a2
		  ON a1.city <> a2.city;