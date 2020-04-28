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
				String departureDate = date + " " + request.getParameter("departure_time") + ":00";
				String arrivalDate = date + " " +  request.getParameter("arrival_time") + ":00";
				String departureTime = request.getParameter("departure_time") + ":00";
				String arrivalTime = request.getParameter("arrival_time") + ":00";
				
				//out.println("Departure time: " + departureTime);
				//out.println("Arrival time: " + arrivalTime);
				
				String checkOnScheduleStr = "SELECT DISTINCT f.line_name, f.train_id, f.num_seats_available, f.departure_time, f.arrival_time "
						+ "FROM follows_a f "
						+ "WHERE (f.origin_id = ? and f.destination_id = ? and departure_time = ? and arrival_time = ?);";
						
				PreparedStatement checkOnSchedule = conn.prepareStatement(checkOnScheduleStr);
				checkOnSchedule.setString(1, origin);
				checkOnSchedule.setString(2, destination);
				checkOnSchedule.setString(3, departureDate);
				checkOnSchedule.setString(4, arrivalDate);
				
				ResultSet lineRS = checkOnSchedule.executeQuery();
				
				String line = "";
				String tID = "";
				String seats = "";
				Time dTime = null;
				Time aTime = null;
				
				while (lineRS.next()) {
					line = lineRS.getString("line_name");
					tID = lineRS.getString("train_id");
					seats = lineRS.getString("num_seats_available");
					dTime = lineRS.getTime("departure_time");
					aTime = lineRS.getTime("arrival_time");
				}
				
				//out.println(line + "\n");
				//out.println(dTime.toString() + " = " + departureTime + "\n");
				//out.println(aTime.toString() + " = " + arrivalTime + "\n");
				if (seats.equals("0"))
					throw new Exception("There are no seats available on that train!");
				
				if (line != "" && dTime.toString().equals(departureTime) && aTime.toString().equals(arrivalTime)) {
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
					
					String sNum = "";
					String tNum = "";

					if((totalSeats != "") && (seats != "")) {
						sNum = Integer.toString(Integer.parseInt(totalSeats) - Integer.parseInt(seats));
						tNum = Integer.toString(Integer.parseInt(seats) - 1);
					}
					
					String updateFollowsStr = "UPDATE follows_a f "
							+ "SET f.num_seats_available = ? "
							+ "WHERE (f.origin_id = ? and f.destination_id = ? and departure_time = ? and arrival_time = ?);";
					
					PreparedStatement updateFollows = conn.prepareStatement(updateFollowsStr);
					updateFollows.setString(1, tNum);
					updateFollows.setString(2, origin);
					updateFollows.setString(3, destination);
					updateFollows.setString(4, departureDate);
					updateFollows.setString(5, arrivalDate);
					
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
					
					
					//calculate a delay
					
					/*
					String scheduledArrival = "";
					String actualArrival = "";
					String getsched = "SELECT x.arrival_time, y.arrival_time " 
							+ "FROM follows_a x, stops_at y" 
							+ " WHERE x.train_id = y.trainid and x.destination_id = y.station_id";
					
					PreparedStatement getschedQuery = conn.prepareStatement(getsched);
					
					ResultSet rs1 = getschedQuery.executeQuery();
					
					rs1.next();
					scheduledArrival = rs1.getString("time1");
					actualArrival = rs1.getString("time2");
					if(!scheduledArrival.equals(actualArrival)){
						out.print(Attention, Train may be delayed!);
					}
					getschedQuery.close();
					rs1.close();
					*/
					
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