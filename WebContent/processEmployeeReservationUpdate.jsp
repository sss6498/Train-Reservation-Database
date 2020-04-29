<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Process Employee Reservation Update -- Group 31 Railway Booking</title>
</head>
<body>

		<%
			try {
				//reading in parameters
				String resID = request.getParameter("reservation_id");
				String date = request.getParameter("date");
				String passenger = request.getParameter("passenger");
				String total_fare = request.getParameter("total_fare");
				String customer_rep = request.getParameter("customer_rep");
				String origin = request.getParameter("origin");
				String destination = request.getParameter("destination");
				String transit_line = request.getParameter("transit_line");
				String departure = request.getParameter("departure");
				String seat_num = request.getParameter("seat_num");
				String seat_class = request.getParameter("seat_class");
				String train_num = request.getParameter("train_num");
				String booking_fee = request.getParameter("booking_fee");
				
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				
				//updating reservation row
				String updateEmpAccStr = "UPDATE reservation r "
						+ "SET r.total_fare=?, "
						+ "r.date=?, "
						+ "r.class=?, "
						+ "r.seat_num=?, "
						+ "r.booking_fee=?, "
						+ "r.customer_rep=?, "
						+ "r.username=? "
						+ "WHERE r.reservation_id=?";
						
				PreparedStatement updateEmpAccQuery = conn.prepareStatement(updateEmpAccStr);
				updateEmpAccQuery.setString(1, total_fare);
				updateEmpAccQuery.setString(2, date);
				updateEmpAccQuery.setString(3, seat_class);
				updateEmpAccQuery.setString(4, seat_num);
				updateEmpAccQuery.setString(5, booking_fee);
				updateEmpAccQuery.setString(6, customer_rep);
				updateEmpAccQuery.setString(7, passenger);
				updateEmpAccQuery.setString(8, resID);
				updateEmpAccQuery.executeUpdate();
				updateEmpAccQuery.close();
				
				
				//updating made for row
				String updatemadeforStr = "UPDATE made_for m "
						+ "SET m.train_id=?, "
						+ "m.line_name=? "
						+ "WHERE m.reservation_id=?";
						
				PreparedStatement updatemadeforQuery = conn.prepareStatement(updatemadeforStr);
				updatemadeforQuery.setString(1, train_num);
				updatemadeforQuery.setString(2, transit_line);
				updatemadeforQuery.setString(3, resID);
				updatemadeforQuery.executeUpdate();
				updatemadeforQuery.close();
				
				
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