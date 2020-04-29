<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Process Stop Update -- Group 31 Railway Booking</title>
</head>
<body>


	<%
	//reading in parameters 
	String transit_line_name = request.getParameter("line_name");
	String train = request.getParameter("train_id");
	String num_stops_str = request.getParameter("stop_num").toString();
	int num_stops = Integer.parseInt(num_stops_str);
	String arrival_month = null; 
	String arrival_day = null;
	String arrival_year = null;
	String arrival_hour = null;
	String arrival_min = null;
	String departure_month = null; 
	String departure_day = null;
	String departure_year = null;
	String departure_hour = null;
	String departure_min = null;
	String station_id = null;
	
	
	try {
		
		//The url of our database
		String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
		
		Class.forName("com.mysql.jdbc.Driver");
		
		//Attempting to make a connection to database
		Connection conn = DriverManager.getConnection(url, "group31", "database20");
		

		//updating reservation row
		String updateStopsAtStr = "INSERT INTO stops_at "
				+ "VALUES (?, ?, ?, ?, ?) ";
		
		PreparedStatement updateStopsAtQuery = null;
		
		
		
		// need to begin for loop to do insert sql command multiple times 
		
		for (int i=1; i < num_stops+1; i++) {
			
			arrival_month = request.getParameter("arrival_month" + i);
			arrival_day = request.getParameter("arrival_day" + i);
			arrival_year = request.getParameter("arrival_year" + i);
			arrival_hour = request.getParameter("arrival_hour" + i);
			arrival_min = request.getParameter("arrival_min" + i);
			departure_month = request.getParameter("departure_month" + i);
			departure_day = request.getParameter("departure_day" + i);
			departure_year = request.getParameter("departure_year" + i);
			departure_hour = request.getParameter("departure_hour" + i);
			departure_min = request.getParameter("departure_min" + i);
			station_id = request.getParameter("stop" + i);
			
		
			// arrival and departure info received
			
			// combine these values for datetime str
			String arrival = arrival_year 
							+ "-" + arrival_month 
							+ "-" + arrival_day 
							+ " " + arrival_hour
							+ ":" + arrival_min;
			String departure = departure_year
							+ "-" + departure_month
							+ "-" + departure_day
							+ " " + departure_hour
							+ ":" + departure_min;
		
			// all data receieved, ready to insert into query str
			updateStopsAtQuery = conn.prepareStatement(updateStopsAtStr);
			updateStopsAtQuery.setString(2, transit_line_name);
			updateStopsAtQuery.setString(3, train);
			updateStopsAtQuery.setString(1, station_id);
			updateStopsAtQuery.setString(4, arrival);
			updateStopsAtQuery.setString(5, departure);
			
			
			updateStopsAtQuery.executeUpdate();
			updateStopsAtQuery.close();
		}
		
		request.setAttribute("status", "Successful!");
		RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
		rd.forward(request, response);
		
		//closing connections
		conn.close();	
		
	} catch (Exception e){
		request.setAttribute("status", e.getMessage());
		RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
		rd.forward(request, response);
	}

	%>

</body>
</html>