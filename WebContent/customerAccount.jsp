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
		  <option value="Newark Penn Station">Newark Penn Station</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		
		<label for="destination">Destination:</label>
		<select id="destination" name="destination">
		  <option value="Trenton">Trenton</option>
		  <option value="Metropark">Metropark</option>
		  <option value="Newark Penn Station">Newark Penn Station</option>
		  <option value="Philadelphia 30th Street">Philadelphia 30th Street</option>
		  <option value="Cherry Hill">Cherry Hill</option>		
		  <option value="Atlantic City">Atlantic City</option>	
		</select>
		<label for="date">Date of Travel(yyyy-mm-dd):</label>
		  <input type="date" id="date" name="date">	
		<label for="sortby">Sort By:</label>
		<select id="sortby" name="sortby">
		  <option value="d.arrival_time">Arrival Time</option>
		  <option value="o.departure_time">Departure Time</option>
		  <option value="s.name">Origin</option>	
		  <option value="s.name">Destination</option>
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
			<% 
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				
				String getStationsStr = "SELECT s.station_id, s.name "
						+ "FROM station s;";

				
				PreparedStatement getStationsQuery = conn.prepareStatement(getStationsStr);
				
				
				ResultSet rs = getStationsQuery.executeQuery();
				
				//closing all objects

				
				while(rs.next()){ 
				String stat = rs.getString("station_id");
				String name = rs.getString("name");
				%>
				
			    <option value=<%=stat%> id=<%=name%>><%=name%></option>
			<%
				}
				
				getStationsQuery.close();
				conn.close();
				
				}catch(Exception e){
					System.out.print(e.getMessage());
					System.out.print("<br>");
					System.out.print("Sorry, no stations could be found.");
				}
			%>
		</select>
		
		<label for="destination">Destination:</label>
		<select id="destination" name="destination">
			<% 
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				
				String getStationsStr = "SELECT s.station_id, s.name "
						+ "FROM station s;";

				
				PreparedStatement getStationsQuery = conn.prepareStatement(getStationsStr);
				
				
				ResultSet rs = getStationsQuery.executeQuery();
				
				//closing all objects

				
				while(rs.next()){ 
				String stat = rs.getString("station_id");
				String name = rs.getString("name");
				%>
				
			    <option value=<%=stat%> id=<%=name%>><%=name%></option>
			<%
				}
				
				getStationsQuery.close();
				conn.close();
				
				}catch(Exception e){
					System.out.print(e.getMessage());
					System.out.print("<br>");
					System.out.print("Sorry, no stations could be found.");
				}
			%>
		</select>
		<label for="date">Date of Travel(yyyy-mm-dd):</label>
		  <input type="text" id="date" name="date">
		<label for="date">Time of departure (hh:mm):</label>
		  <input type="text" id="departure_time" name="departure_time">
		<label for="date">Time of arrival (hh:mm):</label>
		  <input type="text" id="arrival_time" name="arrival_time">
		<label for="total_fare">Type of ticket:</label>
		<select id="total_fare" name="total_fare">
			<option value="discounted_oneway">Discounted Oneway (Senior/Disabled)</option>
			<option value="discounted_roundtrip">Discounted Roundtrip (Senior/Disabled)</option>
			<option value="monthlypass">Monthly Pass</option>
			<option value="standard_oneway">Standard Oneway</option>
			<option value="standard_roundtrip">Standard Roundtrip</option>
			<option value="weeklypass">Weekly Pass</option>
		</select>
		<label for="seatClass">Class of seat:</label>
		<select id="seatClass" name="seatClass">
			<option value="Economy">Economy</option>
			<option value="Business">Business</option>
			<option value="First">First</option>
		</select>
		<input type="hidden" id="username" name="username" value=<%=username%>>
		<input type="submit" value="Submit">
	</form>

	<br>
		<form method=post action=customerQuestion.jsp>
			<label for="quesCreate"> Need help? Ask a question: </label>
			<input name="question" id="quesCreate" type="text">
			<input type="submit" value="Submit!">
		</form>
		<%session.setAttribute("username", request.getParameter("username")); %>
		<form method=get action=browseQuestions.jsp>
				OR
			<label for="browseQues"></label>
			<input type="submit" value="Browse/Search Questions">
			<br>
		</form>
		

	</body>
</html>