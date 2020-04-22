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
		<select id="origin">
		  <option value="f.origin_id">ALL</option>
		  <option value="Trenton">Trenton</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>	
		</select>
		
		<label for="destination">Destination:</label>
		<select id="destination">
		  <option value="s.name">ALL</option>
		  <option value="Newark">Newark</option>
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		<label for="date">Date of Travel(yyyy-mm-dd):</label>
		  <input type="text" id="date" name="date">	
		<label for="sortby">Sort By:</label>
		<select id="sortby">
		  <option value="f.arrival_time">Arrival Time</option>
		  <option value="f.departure_time">Departure Time</option>
		  <option value="f.origin_id">Origin</option>	
		  <option value="s.name">Station Name</option>
		  <option value="r.total_fare">Total Fare</option>
		</select>
		<input type="submit" value="Submit">
		</form>	

	</body>
</html>