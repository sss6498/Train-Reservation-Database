<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Train Schedule</title>
</head>
<body>
Below are the train reservations for your search:

<%
			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting selections from customerAccount.jsp
				String origin = request.getParameter("origin");
				String destination = request.getParameter("destination");
				String date = request.getParameter("date");
				String sortby = request.getParameter("sortby");
				
				//Retreiving schedule from database
				String scheduleLookupStr = "SELECT DISTINCT r.reservation_id, r.seat_num, r.class, r.total_fare, r.date, s.name, m.line_name, p.arrival_time, p.departure_time "
						+ "FROM reservation r, made_for m, follows_a f, stops_at p, station s "
						+ "WHERE r.reservation_id=m.reservation_id AND m.train_id=f.train_id AND f.train_id=p.train_id AND m.line_name=p.line_name AND p.station_id = s.station_id "
						+ "AND s.name = ? AND p.arrival_time < (SELECT max(p.arrival_time) from station s, stops_at p WHERE s.station_id=p.station_id AND s.name = ? ) "
						+ "AND r.date = ? "
						+ "ORDER BY ? ;";
				
				String lineLookupStr = "Select DISTINCT s.name from station s, stops_at p Where s.station_id=p.station_id AND p.line_name IN ( "
						+ "Select p.line_name FROM station s, stops_at p WHERE s.station_id=p.station_id AND (s.name = ? OR s.name = ? ));";
				
				PreparedStatement scheduleLookupQuery = conn.prepareStatement(scheduleLookupStr);
				PreparedStatement lineLookupQuery = conn.prepareStatement(lineLookupStr);
				
				scheduleLookupQuery.setString(1, origin);
				scheduleLookupQuery.setString(2, destination);
				scheduleLookupQuery.setString(3, date);
				scheduleLookupQuery.setString(4, sortby);
				
				lineLookupQuery.setString(1,origin);
				lineLookupQuery.setString(2, destination);

				//Executing the query
				ResultSet result = scheduleLookupQuery.executeQuery();
				ResultSet result2 = lineLookupQuery.executeQuery();
				%>
				<!-- Parsing results -->
				<table BORDER="1">
	            <TR>
	                <TH>Reservation ID</TH>
	                <TH>Seat Number</TH>
	                <TH>Class</TH>
	                <TH>Total Fare</TH>
	                <TH>Date</TH>
	                <TH>Station Name</TH>
	                <TH>Line Name</TH>
	                <TH>Arrival Time</TH>
	                <TH>Departure Time</TH>
	            </TR>
	             

	           <% while(result.next()) { %>
	            <TR>
	                <TD> <%= result.getInt(1) %></td>
	                <TD> <%= result.getInt(2) %></TD>
	                <TD> <%= result.getString(3) %></TD>
	                <TD> <%= result.getDouble(4) %></TD>
	                <TD> <%= result.getDate(5) %></TD>
	                <TD> <%= result.getString(6) %></TD>
	                <TD> <%= result.getString(7) %></TD>
	                <TD> <%= result.getTime(8) %></TD>
	                <TD> <%= result.getTime(9) %></TD>

	            </TR>
	            <% } %>
	        </TABLE>
	        
	     <br>
	     <br>
		
		Here is the list of all the stops along this train line
		<table BORDER="1">
	            <TR>
	                <TH>Stop Name</TH>
	            </TR>
	           <% while(result2.next()) { %>
	            <TR>
	                <TD> <%= result2.getString(1) %></td>
	            </TR>
	            <% } %>
	        </TABLE>
		
		
		<%
				//closing all objects
				result.close();
				result2.close();
				scheduleLookupQuery.close();
				lineLookupQuery.close();
				conn.close();
				
			}catch(Exception e){
				out.print(e);
				out.print("<br>");
				out.print("Sorry, the schedule you are looking for does not exist.");
			}
		%>
</body>
</html>