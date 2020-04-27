<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>    
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Create Reservation: Group 31 Railway Booking</title>
	</head>
	<body>
		<%
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting username from customerAccount.jsp
				String reservationID = request.getParameter("reservation_id");
				String username = request.getParameter("username");
				
				String delResInfoStr = "DELETE FROM reservation "
						+ "WHERE (reservation_id = ? AND username = ?);";

				
				PreparedStatement delResInfoQuery = conn.prepareStatement(delResInfoStr);
				
				delResInfoQuery.setString(1, reservationID);
				delResInfoQuery.setString(2, username);
				
				delResInfoQuery.executeUpdate();
						
				String delMadeForStr = "DELETE FROM made_for "
						+ "WHERE reservation_id = ?";
				
				PreparedStatement delMadeFor = conn.prepareStatement(delMadeForStr);
				
				delMadeFor.setString(1, reservationID);
				
				delMadeFor.executeUpdate();
				
				out.println("Reservation Deleted!");
				
				//closing all objects
				delMadeFor.close();
				delResInfoQuery.close();
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Sorry, your reservation could not be deleted.");
			}
		%>
	</body>
</html>