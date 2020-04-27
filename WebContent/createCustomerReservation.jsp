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
				String username = request.getParameter("username");
				String totalFare = request.getParameter("total_fare");
				String date = request.getParameter("date");
				String seatClass = request.getParameter("seatClass");
				String origin = request.getParameter("origin");
				String destination = request.getParameter("destination");
				
				String checkOnSchedule1Str = "SELECT t.line_name "
						+ "FROM train_schedule t "
						+ "WHERE t.origin = ?;";
						
				String checkOnSchedule2Str = "SELECT t.line_name "
						+ "FROM train_schedule t "
						+ "WHERE t.destination = ?;";		
						
				PreparedStatement checkOnSchedule1 = conn.prepareStatement(checkOnSchedule1Str);
				checkOnSchedule1.setString(1, origin);
				
				PreparedStatement checkOnSchedule2 = conn.prepareStatement(checkOnSchedule2Str);
				checkOnSchedule2.setString(1, destination);
				
				ResultSet originRS = checkOnSchedule1.executeQuery();			
				ResultSet destinationRS = checkOnSchedule2.executeQuery();
				
				String o = "";
				String d = "";
				
				while (originRS.next())
					o = originRS.getString(1);
				
				while (destinationRS.next())
					d = destinationRS.getString(1);
				
				
				if (o.equals(d)) {
					String resIDMakeStr = "SELECT MAX(r.reservation_id)"
							+ "FROM reservation r;";
							
					PreparedStatement resIDMakeQuery = conn.prepareStatement(resIDMakeStr);
					
					ResultSet rs = resIDMakeQuery.executeQuery();
					
					String newResID = "";
					
					while (rs.next())
						newResID = rs.getString(1);
					
					int temp = Integer.parseInt(newResID) + 1;
					
					newResID = Integer.toString(temp);
			
					
					//Looking up the account in the database
					String createResInfoStr = "INSERT INTO reservation(reservation_id, total_fare, date, class, seat_num, booking_fee, username) "
							+ "VALUES (?, ?, ?, ?, ?, ?, ?);";
					
					PreparedStatement createResInfoQuery = conn.prepareStatement(createResInfoStr);
					
					createResInfoQuery.setString(1, newResID);
					createResInfoQuery.setString(2, totalFare);
					createResInfoQuery.setString(3, date);
					createResInfoQuery.setString(4, seatClass);
					createResInfoQuery.setString(5, "0");
					createResInfoQuery.setString(6, "10");
					createResInfoQuery.setString(7, username);
					
					createResInfoQuery.executeUpdate();
					
					String getTrainIDStr = "SELECT t.train_id "
							+ "FROM train_schedule t "
							+ "WHERE (t.origin = ? AND t.destination = ?);";	
							
					PreparedStatement getTrainID = conn.prepareStatement(getTrainIDStr);
					
					getTrainID.setString(1, origin);
					getTrainID.setString(2, destination);
					
					ResultSet rsID = getTrainID.executeQuery();
					
					String train_id = "";
					
					while (rs.next())
						train_id = rsID.getString(1);
							
					String updateMadeForStr = "INSERT INTO made_for(train_id, line_name, reservation_id) "
							+ "VALUES (?, ?, ?)";
					
					PreparedStatement updateMadeFor = conn.prepareStatement(updateMadeForStr);
					
					updateMadeFor.setString(1, train_id);
					updateMadeFor.setString(2, o);
					updateMadeFor.setString(3, newResID);
					
					updateMadeFor.executeUpdate();
					
					out.println("Reservation Created!");
					
					//closing all objects

					updateMadeFor.close();
					createResInfoQuery.close();
					resIDMakeQuery.close();
				}
				else {
					out.println("Sorry, your reservation could not be made. Please pick a valid origin and destination");
				}
				
				checkOnSchedule1.close();
				checkOnSchedule2.close();
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Sorry, your reservation could not be created.");
			}
		%>
	</body>
</html>