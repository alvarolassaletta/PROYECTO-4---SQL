--1.Listar todos los aeropuertos con su ciudad y zona horaria:

SELECT  airport_name, city, timezone
FROM airports_data;

--2.Contar cuántos vuelos tiene cada aeropuerto de salida:

SELECT departure_airport, COUNT(flight_id)
FROM flights
GROUP BY departure_airport
ORDER BY COUNT(flight_id) DESC;


--3.Mostrar todos los asientos disponibles por tipo de tarifa:

SELECT aircraft_code, fare_conditions, COUNT(seat_no)
FROM seats 
GROUP BY aircraft_code, fare_conditions
ORDER BY COUNT(seat_no) DESC;


--4.Obtener todos los vuelos programados para una fecha específica, por ejemplo '2017-08-13';

SELECT flight_id, flight_no, scheduled_departure, aircraft_code, departure_airport, arrival_airport
FROM flights 
WHERE  DATE(scheduled_departure) = '2017-08-13';


--5. Listar pasajeros y su vuelo:

SELECT F.flight_id, F.flight_no, T.passenger_id, T.passenger_name
FROM flights F
JOIN ticket_flights TF ON F.flight_id = TF.flight_id
JOIN  tickets T  ON TF.ticket_no = T.ticket_no;

--5.2 Cuenta el numero de pasajeros por  vuelo 

SELECT F.flight_id, COUNT(T.passenger_name) AS number_of_passengers_by_flight
FROM flights F 
JOIN ticket_flights TF ON F.flight_id = TF.flight_id
JOIN tickets T ON TF.ticket_no = T.ticket_no 
GROUP BY F.flight_id
ORDER BY number_of_passengers_by_flight DESC;

--6 Total de ingresso por vuelo 

SELECT flight_id, SUM(amount) AS total_revenue_by_flight
FROM ticket_flights 
GROUP BY  flight_id
ORDER BY total_revenue_by_flight DESC;


--7. Pasajeros con más de un vuelo reservado:

SELECT  passenger_name, COUNT(passenger_id) AS more_than_one_ticket
FROM tickets 
GROUP BY passenger_name
HAVING COUNT(passenger_id) > 1
ORDER BY  more_than_one_ticket DESC;

--7.2 Pasajeros con más de un vuelo reservado   para una fecha concreta un y vuelo concreto 

SELECT  T.passenger_name, 
		F.flight_id, 	
		F.flight_no,
		F.scheduled_departure,
		COUNT(T.passenger_id) AS ticket_count 
FROM  tickets T
JOIN ticket_flights TF ON T.ticket_no =TF.ticket_no
JOIN flights F ON  TF.flight_id= F.flight_id
WHERE DATE(F.scheduled_departure)='2017-08-13' AND F.flight_no='PG0406'
GROUP BY T.passenger_name,F.flight_id,F.flight_no, F.scheduled_departure
HAVING COUNT(T.passenger_id)>1;
  

--8. Obtén el número total de vuelos por cada código de aeronave (aircraft_code)

SELECT aircraft_code ,COUNT(flight_id) AS total_flights_by_aircraft
FROM flights 
GROUP BY aircraft_code
ORDER BY total_flights_by_aircraft DESC;

--9. Muestra la cantidad de reservas realizadas cada mes en 2017.

/*Esto no funciona en POSTGRES porque por lo visto no existe ni MONTH ni YEAR
Hay que usar EXTRACT( MONTH FROM _CAMPO)  EXTRACT(YEAR FROM campo) */

SELECT MONTH(book_date), COUNT(book_ref) AS total_bookings_by_month
FROM bookings 
WHERE YEAR(book_date) = 2014
GROUP BY MONTH(book_date);

	

SELECT EXTRACT(MONTH FROM book_date) AS month, COUNT(book_ref) AS total_bookings_by_month
FROM bookings 
WHERE EXTRACT(YEAR FROM book_date) = 2017
GROUP BY  month;



--11. Lista los vuelos que salen de un aeropuerto concreto y llegan a otro concreto. Por ejemplo DME Y KUF 

SELECT flight_id,flight_no,departure_airport,arrival_airport 
FROM flights 
WHERE departure_airport= 'DME' AND arrival_airport = 'KUF';

--12. Calcula el número de pasajeros por vuelo usando la tabla boarding_passes.

SELECT F.flight_id, F.flight_no, COUNT(BP.boarding_no) boarding_passes_count
FROM flights F
JOIN ticket_flights TF ON F.flight_id = TF.flight_id
JOIN  boarding_passes BP ON TF.ticket_no = BP.ticket_no
GROUP BY F.flight_id,F.flight_no
ORDER BY boarding_passes_count DESC;


--13. Muestra el total gastado por cada pasajero, ordenado de mayor a menor gasto.

SELECT T.passenger_id,T.passenger_name, SUM(DISTINCT B.total_amount) AS total_expensed_by_passenger
FROM tickets T 
JOIN bookings B ON T.book_ref = B.book_ref
GROUP BY T.passenger_name,T.passenger_id
ORDER BY total_expensed_by_passenger DESC;

--14. Encuentra los 5 aeropuertos con más salidas de vuelos.
SELECT A.airport_code, A.airport_name, COUNT(F.departure_airport) total_departure_flights_by_airport
FROM  airports_data A
JOIN flights F ON A.airport_code = F.departure_airport
GROUP BY A.airport_name,A.airport_code
ORDER BY total_departure_flights_by_airport DESC
LIMIT 5;
