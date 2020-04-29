<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Reservation editing 3 -- Group 31 Railway Booking</title>
</head>
<body>


<% 
			String resID = null;
			String date = null;
			String passenger = null;
			String customer_rep = null;
			String origin = null;
			String destination = null;
			String transit_line = null;
			String departure = null;
			String seat_num = null;
			String seat_class = null;
			String train_num = null;
			String booking_fee_str = null;
			String purchase_type = null;
			String pt_val = null;
			float total_fare = 0;
			String avail_seats_str = null;
			String total_seats_str = null;
			
			
			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				resID = request.getParameter("reservation_id");
				date = request.getParameter("date");
				passenger = request.getParameter("passenger");
				customer_rep = request.getParameter("customer_rep");
				origin = request.getParameter("origin");
				destination = request.getParameter("destination");
				transit_line = request.getParameter("transit_line");
				departure = request.getParameter("departure");
				seat_num = null;
				train_num = request.getParameter("train_num");
				booking_fee_str = request.getParameter("booking_fee");
				purchase_type = request.getParameter("purchase_type");
				seat_class = request.getParameter("seat_class");
				
				float booking_fee = Float.parseFloat(booking_fee_str);
				
				// get the train fare from db 
				String getFare = "SELECT f.amount " 
							+ "FROM fare f "
							+ "WHERE f.line_name=? "
							+ "AND f.train_id=? "
							+ "AND f.type=?";
				PreparedStatement getFareQuery = conn.prepareStatement(getFare);
				getFareQuery.setString(1, transit_line);
				getFareQuery.setString(2, train_num);
				getFareQuery.setString(3, purchase_type);
				ResultSet rs = getFareQuery.executeQuery();
				//parsing results for reservation 
				rs.next();
				String fare_str = rs.getString("f.amount");
				
				float train_fare = Float.parseFloat(fare_str);
				
				if (seat_class.equals("business")){
					// price will doubled for business class
					train_fare = train_fare * 2;
				} else if (seat_class.equals("first")){
					train_fare = train_fare * 3;
				}
				
				// calculate the total fare 
				total_fare = train_fare + booking_fee;
				
				
				// find the seat number 
				String getSeatNum = "SELECT f.num_seats_available, t.num_of_seats " 
							+ "FROM follows_a f, train t "
							+ "WHERE f.train_id = t.train_id "
							+ "AND f.train_id=? "
							+ "AND f.line_name=?";
				PreparedStatement getSeatNumQuery = conn.prepareStatement(getSeatNum);
				getSeatNumQuery.setString(1, train_num);
				getSeatNumQuery.setString(2, transit_line);
				ResultSet rs1 = getSeatNumQuery.executeQuery();
				
				rs1.next();
				avail_seats_str = rs1.getString("f.num_seats_available");
				total_seats_str = rs1.getString("t.num_of_seats");
				int avail_seats = Integer.parseInt(avail_seats_str);
				int total_seats = Integer.parseInt(total_seats_str);
				
				int seat_number = total_seats - avail_seats + 1;
				seat_num = "" + seat_number;
				
				// update num seats available with one less
				String updateSeatsStr = "UPDATE follows_a "
						+ "SET follows_a.num_seats_available=? "
						+ "WHERE follows_a.train_id=? "
						+ "AND follows_a.line_name=?";
						
				PreparedStatement updateSeatsQuery = conn.prepareStatement(updateSeatsStr);
				updateSeatsQuery.setInt(1, avail_seats-1);
				updateSeatsQuery.setString(2, train_num);
				updateSeatsQuery.setString(3, transit_line);
				updateSeatsQuery.executeUpdate();
				updateSeatsQuery.close();
				
				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			
			// add in fields to edit below 
			
		%>

<b><u> Review Total Fare below and press continue!</u></b>
			
		<br>
		<br>
		
		<form method="post" action="processEmployeeReservationUpdate.jsp">
		
		
			<label for="total_fare"> Total Fare: </label>
			<input name="total_fare" id="total_fare" type="text" readonly = "readonly" value="<% out.print(total_fare); %>">
			<br>
			<br>
		
			<label for="purchase_type"> Purchase Type: </label>
			<input name="purchase_type" id="purchase_type" type="text" readonly = "readonly" value="<% out.print(purchase_type); %>">
			<br>
		
			<label for="reservation_id"> Reservation ID:</label>
			<input name="reservation_id" id="reservation_id" type="text" readonly = "readonly" value="<% out.print(resID); %>">
			<br>
		
			<label for="date"> Date:</label>
			<input name="date" id="date" type="text" readonly = "readonly" value="<% out.print(date); %>">
			<br>
			
			<label for="passenger"> Passenger Username: </label>
			<input name="passenger" id="passenger" type="text" readonly = "readonly" value="<% out.print(passenger); %>">
			<br>

			<label for="booking_fee"> Booking Fee: </label>
			<input name="booking_fee" id="booking_fee" type="text" readonly = "readonly" value="<% out.print(booking_fee_str); %>">
			<br>
			
			<label for="customer_rep"> Customer Representative: </label>
			<input name="customer_rep" id="customer_rep" type="text" readonly = "readonly" value="<% out.print(customer_rep); %>">
			<br>
			
			<label for="origin"> Origin: </label>
			<input name="origin" id="origin" type="text" readonly = "readonly" value="<% out.print(origin); %>">
			<br>
			
			<label for="destination"> Destination:</label>
			<input name="destination" id="destination" type="text" readonly = "readonly" value="<% out.print(destination); %>">
			<br>
			
			<label for="transit_line"> Transit Line:</label>
			<input name="transit_line" id="transit_line" type="text" readonly = "readonly" value="<% out.print(transit_line); %>">
			<br>
			
			<label for="train_num"> Train Number:</label>
			<input name="train_num" id="train_num" type="text" readonly = "readonly" value="<% out.print(train_num); %>">
			<br>
			
			<label for="departure"> Departure:</label>
			<input name="departure" id="departure" type="text" readonly = "readonly" value="<% out.print(departure); %>">
			<br>
			
			<label for="seat_num"> Seat Number:</label>
			<input name="seat_num" id="seat_num" type="text" readonly = "readonly" value="<% out.print(seat_num); %>">
			
			<br>
			<label for="seat_class"> Class:</label>
			<input name="seat_class" id="seat_class" type="text" readonly = "readonly" value="<% out.print(seat_class); %>">
			
			<br>
			<br>
			<input type="submit" value="Continue!">
		</form>



</body>
</html>