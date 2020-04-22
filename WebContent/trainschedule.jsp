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
				String scheduleLookupStr = "SELECT r.reservation_id, r.seat_num, r.class, r.date, r.total_fare, s.name "
						+ "FROM reservation r, made_for m, follows_a f, stops_at p, station s "
						+ "WHERE r.reservation_id=m.reservation_id AND m.line_name=f.line_name AND f.line_name=p.line_name "
						+ "AND p.line_name = ( "
							+ "SELECT p.line_name "
							+ "FROM stops_at p, follows_a f, station s "
							+ "WHERE f.line_name = p.line_name AND p.station_id = s.station_id "
							+ "AND (s.name = ? OR s.name = ? )) "
						+ "AND r.date = ? " 
						+ "ORDER BY ? ;";

				
				PreparedStatement scheduleLookupQuery = conn.prepareStatement(scheduleLookupStr);
				scheduleLookupQuery.setString(1, origin);
				scheduleLookupQuery.setString(2, destination);
				scheduleLookupQuery.setString(3, date);
				scheduleLookupQuery.setString(4, sortby);
				
				//Executing the query
				ResultSet result = scheduleLookupQuery.executeQuery();
				
				//Parsing results
				result.next();
								
				//closing all objects
				result.close();
				scheduleLookupQuery.close();
				conn.close();
				
			}catch(Exception e){
				out.print(e);
				out.print("<br>");
				out.print("Sorry, the schedule you are looking for does not exist.");
			}
		%>
</body>
</html>