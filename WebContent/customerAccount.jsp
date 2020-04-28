<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Customer Account -- Group 31 Railway Booking</title>
	</head>
	<body>
		Welcome, 
		<% 
			String username = request.getParameter("username");
			out.print(username);
		%>
		
		<br>
		
		<form method=get action=index.jsp>
			<input type="submit" value="Logout!">
		</form>
	<form action="trainschedule.jsp">
		Search for train schedule reservations:
		<label for="origin">Origin:</label>
		<select id="origin" name="origin">
		  <option value="Trenton">Trenton</option>
		  <option value="Metropark">Metropark</option>
		  <option value="Newark">Newark</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		
		<label for="destination">Destination:</label>
		<select id="destination" name="destination">
		  <option value="Trenton">Trenton</option>
		  <option value="Metropark">Metropark</option>
		  <option value="Newark">Newark</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		<label for="date">Date of Travel(yyyy-mm-dd):</label>
		  <input type="date" id="date" name="date">	
		<label for="sortby">Sort By:</label>
		<select id="sortby" name="sortby">
		  <option value="f.arrival_time">Arrival Time</option>
		  <option value="f.departure_time">Departure Time</option>
		  <option value="f.origin_id">Origin</option>	
		  <option value="s.name">Station Name</option>
		  <option value="r.total_fare">Total Fare</option>
		</select>
		<input type="submit" value="Submit">
		</form>
	
	<br>
	
	<form action="reservationHistory.jsp">
		Click this button to see all your current and past reservations (you can cancel a reservation here):
			<input type="hidden" id="username" name="username" value=<%=username%>>
		<input type="submit" value ="Submit">
	</form>
	
	<br>
	
	<form action="createCustomerReservation.jsp">
		Create a reservation:
		<label for="origin">Origin:</label>
		<select id="origin" name="origin">
		  <option value="Trenton">Trenton</option>
		  <option value="Metropark">Metropark</option>
		  <option value="Newark">Newark</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		
		<label for="destination">Destination:</label>
		<select id="destination" name="destination">
		  <option value="Trenton">Trenton</option>
		  <option value="Metropark">Metropark</option>
		  <option value="Newark">Newark</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>		
		</select>
		<label for="date">Date of Travel(yyyy-mm-dd):</label>
		  <input type="text" id="date" name="date">
		<label for="date">Time of departure (hh:mm):</label>
		  <input type="text" id="departure_time" name="departure_time">
		<label for="date">Time of arrival (hh:mm):</label>
		  <input type="text" id="arrival_time" name="arrival_time">
		<label for="total_fare">Type of passenger:</label>
		<select id="total_fare" name="total_fare">
			<option value="5">Adult</option>
			<option value="3">Senior</option>
			<option value="2">Disabled</option>
		</select>
		<label for="seatClass">Type of passenger:</label>
		<select id="seatClass" name="seatClass">
			<option value="Economy">Economy</option>
			<option value="Business">Business</option>
			<option value="First">First</option>
		</select>
		<input type="hidden" id="username" name="username" value=<%=username%>>
		<input type="submit" value="Submit">
	</form>

	</body>
</html>