<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules for Specific Station -- Group 31 Railway Booking</title>
</head>
<body>

		<% 

		String station = request.getParameter("station");
		String origin_destination = request.getParameter("origin_destination");
		String station_name = null;
		String line_name = null;
		String train_id = null;
		String departure_time = null;
		String arrival_time = null;
		String origin = null;
		String destination = null;
		
		
		try{
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
			
			String getStation = "SELECT s.name FROM station s WHERE s.station_id = ?";
			PreparedStatement getStationQuery = conn.prepareStatement(getStation);
			getStationQuery.setString(1, station);
			ResultSet rs = getStationQuery.executeQuery();
			rs.next();
			station_name = rs.getString("s.name");
		
			out.println("<br>");
			
			out.print("<TABLE BORDER=1>");
			out.print("<TR>");
			out.print("<TH>Origin Station</TH>");
			out.print("<TH>Destination Station</TH>");
			out.print("<TH>Transit Line Name</TH>");
			out.print("<TH>Train Number</TH>");
			out.print("<TH>Departure Time</TH>");
			out.print("<TH>Arrival Time</TH>");
			out.print("</TR>");
			
		if (origin_destination.equals("origin")) {
			
			String getData = "SELECT s.name, f.line_name, f.train_id, f.departure_time, f.arrival_time " 
					+ "FROM follows_a f, station s "
					+ "WHERE f.origin_id = ? "
					+ "AND f.destination_id = s.station_id";
			PreparedStatement getDataQuery = conn.prepareStatement(getData);
			getDataQuery.setString(1, station);
			rs = getDataQuery.executeQuery();
			
			
			while(rs.next() != false) {
				destination = rs.getString("s.name");
				line_name = rs.getString("f.line_name");
				train_id = rs.getString("f.train_id");
				try{
					departure_time = rs.getString("f.departure_time");
				}catch(Exception e){
					departure_time = null;
				}
				try{
					arrival_time = rs.getString("f.arrival_time");
				}catch(Exception e){
					arrival_time = null;
				}
				
				out.print("<TR>");
				out.print("<TD>" + station_name + "</TH>");
				out.print("<TD>" + destination + "</TH>");
				out.print("<TD>" + line_name + "</TH>");
				out.print("<TD>" + train_id + "</TH>");
				out.print("<TD>" + departure_time + "</TH>");
				out.print("<TD>" + arrival_time + "</TH>");
				out.print("</TR>");
			}
			
		} else {
			
			String getData2 = "SELECT s.name, f.line_name, f.train_id, f.departure_time, f.arrival_time " 
					+ "FROM follows_a f, station s "
					+ "WHERE f.destination_id = ? "
					+ "AND f.origin_id = s.station_id";
			PreparedStatement getData2Query = conn.prepareStatement(getData2);
			getData2Query.setString(1, station);
			rs = getData2Query.executeQuery();
			
			while(rs.next() != false) {
				origin = rs.getString("s.name");
				line_name = rs.getString("f.line_name");
				train_id = rs.getString("f.train_id");
				try{
					departure_time = rs.getString("f.departure_time");
				}catch(Exception e){
					departure_time = null;
				}
				try{
					arrival_time = rs.getString("f.arrival_time");
				}catch(Exception e){
					arrival_time = null;
				}
				
				out.print("<TR>");
				out.print("<TD>" + origin + "</TH>");
				out.print("<TD>" + station_name + "</TH>");
				out.print("<TD>" + line_name + "</TH>");
				out.print("<TD>" + train_id + "</TH>");
				out.print("<TD>" + departure_time + "</TH>");
				out.print("<TD>" + arrival_time + "</TH>");
				out.print("</TR>");
			}
		}
			out.print("</TABLE>");
			
			rs.close();
	
		}
		catch (Exception e) {
			request.setAttribute("status", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
			rd.forward(request, response);
			
		}
	
	%>

	<br>
	<br>
	
	<form method="post" action="employeeAccount.jsp">
			<input type="submit" value="Go back to Account!">
		</form>





</body>
</html>