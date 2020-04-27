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
				
				String checkOnScheduleStr = "SELECT f.line_name, f.train_id, f.num_seats_available "
						+ "FROM follows_a f "
						+ "WHERE (f.origin_id = ? and f.destination_id = ?);";
						
				PreparedStatement checkOnSchedule = conn.prepareStatement(checkOnScheduleStr);
				checkOnSchedule.setString(1, origin);
				checkOnSchedule.setString(2, destination);
				
				ResultSet lineRS = checkOnSchedule.executeQuery();
				
				String line = "";
				String tID = "";
				String seats = "";
			
				
				while (lineRS.next()) {
					line = lineRS.getString("line_name");
					tID = lineRS.getString("train_id");
					out.println(tID);
					seats = lineRS.getString("num_seats_available");
				}
				
				if (line != null) {
					
					String resIDMakeStr = "SELECT MAX(r.reservation_id) "
							+ "FROM reservation r;";
							
					PreparedStatement resIDMakeQuery = conn.prepareStatement(resIDMakeStr);
					
					ResultSet rs = resIDMakeQuery.executeQuery();
					
					String newResID = "";

					while (rs.next())
						newResID = rs.getString(1);
					
					int temp = Integer.parseInt(newResID) + 1;
					
					newResID = Integer.toString(temp);

					String getTotalSeatsStr = "SELECT t.num_of_seats "
						 + "FROM train t "
						 + "WHERE t.train_id = ?;";
						 
					PreparedStatement getTotalSeats = conn.prepareStatement(getTotalSeatsStr);
					getTotalSeats.setString(1, tID);
					
					ResultSet seatRS = getTotalSeats.executeQuery();
						 
					String totalSeats = "";
	
					while (seatRS.next())
						totalSeats = seatRS.getString(1);
					
										
					//out.println(totalSeats);
					//out.println(seats);
					//out.println("YO JOSUKE");

					String sNum = "0";
					String tNum = "0";
					if((totalSeats != null) && (seats != null)) {
						sNum = Integer.toString(Integer.parseInt(totalSeats) - Integer.parseInt(seats));
						tNum = Integer.toString(Integer.parseInt(seats) - 1);
					}
					
					String updateFollowsStr = "UPDATE follows_a f "
							+ "SET f.num_seats_available = ? "
							+ "WHERE (f.origin_id = ? and f.destination_id = ?);";
					
					PreparedStatement updateFollows = conn.prepareStatement(updateFollowsStr);
					updateFollows.setString(1, tNum);
					updateFollows.setString(2, origin);
					updateFollows.setString(3, destination);
					
					updateFollows.executeUpdate();
					//Looking up the account in the database
					String createResInfoStr = "INSERT INTO reservation(reservation_id, total_fare, date, class, seat_num, booking_fee, username) "
							+ "VALUES (?, ?, ?, ?, ?, ?, ?);";
					PreparedStatement createResInfoQuery = conn.prepareStatement(createResInfoStr);
					
					createResInfoQuery.setString(1, newResID);
					createResInfoQuery.setString(2, totalFare);
					createResInfoQuery.setString(3, date);
					createResInfoQuery.setString(4, seatClass);
					createResInfoQuery.setString(5, sNum);
					createResInfoQuery.setString(6, "10");
					createResInfoQuery.setString(7, username);
					
					createResInfoQuery.executeUpdate();
					
					String updateMadeForStr = "INSERT INTO made_for(train_id, line_name, reservation_id) "
							+ "VALUES (?, ?, ?)";
		
					PreparedStatement updateMadeFor = conn.prepareStatement(updateMadeForStr);
					
					updateMadeFor.setString(1, tID);
					updateMadeFor.setString(2, line);
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
				
				checkOnSchedule.close();
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Sorry, your reservation could not be created.");
			}
		%>
	</body>
</html>