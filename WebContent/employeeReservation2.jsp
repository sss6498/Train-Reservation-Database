<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Reservation editing 2 -- Group 31 Railway Booking</title>
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
			String seat_class = null;
			String train_num = null;
			String booking_fee = null;
			String purchase_type = null;
			String pt_val = null;
			
			
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
				train_num = request.getParameter("train_num");
				booking_fee = request.getParameter("booking_fee");
				seat_class = request.getParameter("seat_class");
				departure = request.getParameter("departure_time");
				
				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			
			// add in fields to edit below 
			
		%>



		<b><u> Fill out Departure Time and press continue!</u></b>
			
		<br>
		<br>
		
		<form method="post" action="employeeReservation2extra.jsp">
			<!-- Need to add in departure time -->
			
			<!-- this is the departure time drop down box -->
			
			<label for="departure"> Departure:</label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getMaxResID = "SELECT distinct f.departure_time " 
						+ "FROM follows_a f "
						+ "WHERE f.line_name=? ";
				PreparedStatement getQuery = conn.prepareStatement(getMaxResID);
				getQuery.setString(1, transit_line);
				ResultSet rs = getQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "departure_time" id = "departure_time">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("f.departure_time")%></option>
				<% } %>
			</select>
			<% 
			conn.close();
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			
			<br>
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
			<input name="booking_fee" id="booking_fee" type="text" readonly = "readonly" value="<% out.print(booking_fee); %>">
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
			
			
			<label for="seat_class"> Class:</label>
			<%
				if (seat_class.equals("first")){%>
					<input name="seat_class" id="seat_class" type="text" readonly = "readonly" value="first">
				<% }else if (seat_class.equals("business")){ %>
					<input name="seat_class" id="seat_class" type="text" readonly = "readonly" value="business">
				<% }else { // this is economy %>
					<input name="seat_class" id="seat_class" type="text" readonly = "readonly" value="economy">
				<% }
			
			%>
			
			
			<br>
			<br>
			<input type="submit" value="Continue!">
		</form>

</body>
</html>