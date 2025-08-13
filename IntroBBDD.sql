--1. Escribe una consulta que recupere los Vuelos (flights) y su identificador que figuren con status On Time.


SELECT flight_id,flight_no 
FROM flights 
WHERE  LOWER(status) LIKE ('on time');

--2. Escribe una consulta que extraiga todas las columnas de la tabla bookings y refleje todas las reservas que han supuesto una cantidad total mayor a 1.000.000 (Unidades monetarias).

SELECT  * 
FROM bookings 
WHERE total_amount > 1000000;




