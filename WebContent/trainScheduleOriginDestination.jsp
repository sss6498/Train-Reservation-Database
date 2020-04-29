<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules for Specific Origin and Destination -- Group 31 Railway Booking</title>
</head>
<body>

	<% 

		String origin = request.getParameter("origin");
		String destination = request.getParameter("destination");
		String line_name = null;
		String train_id = null;
		String departure_time = null;
		String arrival_time = null;
	
		try{
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
		
			String getData = "SELECT f.line_name, f.train_id, f.departure_time, f.arrival_time " 
					+ "FROM follows_a f "
					+ "WHERE f.origin_id = ? "
					+ "AND f.destination_id = ?";
			PreparedStatement getDataQuery = conn.prepareStatement(getData);
			getDataQuery.setString(1, origin);
			getDataQuery.setString(2, destination);
			ResultSet rs = getDataQuery.executeQuery();
			
			out.println("<br>");
			
			out.print("<TABLE BORDER=1>");
			out.print("<TR>");
			out.print("<TH>Transit Line Name</TH>");
			out.print("<TH>Train Number</TH>");
			out.print("<TH>Departure Time</TH>");
			out.print("<TH>Arrival Time</TH>");
			out.print("</TR>");
			
			
			while(rs.next() != false) {
				line_name = rs.getString("f.line_name");
				train_id = rs.getString("f.train_id");
				departure_time = rs.getString("f.departure_time");
				arrival_time = rs.getString("f.arrival_time");
				
				out.print("<TR>");
				out.print("<TD>" + line_name + "</TH>");
				out.print("<TD>" + train_id + "</TH>");
				out.print("<TD>" + departure_time + "</TH>");
				out.print("<TD>" + arrival_time + "</TH>");
				out.print("</TR>");
				
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