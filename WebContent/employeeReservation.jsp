<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Reservation editing -- Group 31 Railway Booking</title>
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
			String booking_fee = null;
			
			
			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting action and ssn of admin
				String reservationAction = request.getParameter("reservationAction");
				resID = request.getParameter("reservation_id");
				
				
				if (reservationAction.equals("Create a Reservation")){
					
					// need to give it a reservation id - query max reservation id and add 1 
					//getting the max res id of the reservations 
					String getMaxResID = "SELECT max(r.reservation_id) " 
							+ "FROM reservation r ";
					PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
					ResultSet rs = getMaxResIDQuery.executeQuery();
					//parsing results for res id
					rs.next();
					resID =  rs.getString("max(r.reservation_id)");
					int resID_num = Integer.parseInt(resID) + 1;
					// res id is our new reservation id 
					resID = "" + resID_num;
					
					// add reservation data with fields blank 
					String createResStr = "INSERT INTO reservation() "
							+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
					PreparedStatement createResQuery = conn.prepareStatement(createResStr);
					createResQuery.setString(1, "" + resID_num);
					createResQuery.setString(2, "0");
					createResQuery.setString(3, "0000-00-00");
					createResQuery.setString(4, "");
					createResQuery.setString(5, "0");
					createResQuery.setString(6, "0");
					createResQuery.setString(7, "harshil");
					createResQuery.setString(8, "harshil");
					createResQuery.executeUpdate();
					createResQuery.close();
					
					
					
					// add reservation data with fields blank 
					String createmadeforStr = "INSERT INTO made_for() "
							+ "VALUES (?, ?, ?)";
					PreparedStatement createmadeforQuery = conn.prepareStatement(createmadeforStr);
					createmadeforQuery.setString(1, "1");
					createmadeforQuery.setString(2, "Atlantic City Line Northbound");
					createmadeforQuery.setString(3, "" + resID_num);
					createmadeforQuery.executeUpdate();
					createmadeforQuery.close();
					
					
					//closing everything
					rs.close();
					getMaxResIDQuery.close();
					
					
					
				}else if (reservationAction.equals("Edit a Reservation")){
					
					//throwing error if reservation_id is blank
					if (resID.equals("")){
						throw new Exception("Reservation ID Number cannot be blank!");
					}
					
					// need to make all values appear within the form of known fields 
					String getRes = "SELECT * " 
							+ "FROM reservation r "
							+ "WHERE r.reservation_id = ?";
					PreparedStatement getResQuery = conn.prepareStatement(getRes);
					getResQuery.setString(1, resID);
					ResultSet rs = getResQuery.executeQuery();
					//parsing results for reservation 
					rs.next();
					date = rs.getString("date");
					seat_class = rs.getString("class");
					seat_num = rs.getString("seat_num");
					booking_fee = rs.getString("booking_fee");
					customer_rep = rs.getString("customer_rep");
					passenger = rs.getString("username");
					
					out.print("Edit the relevant fields below and submit!");
					
				}else{
					//can just have query to delete account
					
					//throwing error if reservation_id is blank
					if (resID.equals("")){
						throw new Exception("Reservation ID Number cannot be blank!");
					}
					
					
					String reservationDeleteStr = "DELETE FROM reservation "
					+ "WHERE reservation.reservation_id=?";
					PreparedStatement reservationDeleteQuery = conn.prepareStatement(reservationDeleteStr);
					reservationDeleteQuery.setString(1, resID);
					if(reservationDeleteQuery.executeUpdate() == 0){
						throw new Exception("Reservation does not exist!");
					}
					
					//sending result to the adminActionStatus page
					request.setAttribute("status", "Delete Successful!");
					RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
					rd.forward(request, response);
					
					//closing everything
					
					reservationDeleteQuery.close();
					return;
				}
				
				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			
			
			// add in fields to edit below 
			
		%>

		
		<b><u> Fill out the form below and press submit to continue!</u></b>
			
		<br>
		<br>
		
		<form method="post" action="employeeReservation2.jsp">
		
			<label for="reservation_id"> Reservation ID:</label>
			<input name="reservation_id" id="reservation_id" type="text" readonly = "readonly" value="<% out.print(resID); %>">
			<br>
		
			<label for="date"> Date (YYYY-MM-DD):</label>
			<input name="date" id="date" type="text" value="<% 
				String tmp = date != null? date:"";
				out.print(tmp);
			%>">
			
			<br>
			<label for="passenger"> Passenger Username: </label>
			<input name="passenger" id="passenger" type="text" value="<%
				tmp = passenger != null? passenger:"";
				out.print(tmp);
			%>">
			
			<br>
			<label for="booking_fee"> Booking Fee: </label>
			<input name="booking_fee" maxlength="30" id="booking_fee" type="text" value="<%
				tmp = booking_fee != null? booking_fee:"";
				out.print(tmp);
			%>">
			
			<br>
			<label for="customer_rep"> Customer Representative: </label>
			<input name="customer_rep" maxlength="30" id="customer_rep" type="text" value="<%
				tmp = customer_rep != null? customer_rep:"";
				out.print(tmp);
			%>">
			<br>
			
			 <!-- this is the origin drop down box -->
			
			<label for="origin"> Origin: </label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getMaxResID = "SELECT s.name " 
						+ "FROM (select distinct f.origin_id from follows_a f) t1, station s "
						+ "WHERE  s.station_id = t1.origin_id";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "origin" id = "origin">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("s.name")%></option>
				<% } %>
			</select>
			<% 
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			<!-- this is the destination drop down box -->
			<br>
			
			
			<label for="destination"> Destination:</label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getMaxResID = "SELECT s.name " 
						+ "FROM (select distinct f.destination_id from follows_a f) t1, station s "
						+ "WHERE  s.station_id = t1.destination_id";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "destination" id = "destination">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("s.name")%></option>
				<% } %>
			</select>
			<% 
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			<!-- this is the transit line drop down box -->
			
			<br>
			<label for="transit_line"> Transit Line:</label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getMaxResID = "SELECT distinct f.line_name " 
						+ "FROM follows_a f ";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "transit_line" id = "transit_line">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("f.line_name")%></option>
				<% } %>
			</select>
			<% 
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			<!-- this is the departure time drop down box -->
			
			<br>
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
						+ "FROM follows_a f ";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "departure_time" id = "departure_time">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("f.departure_time")%></option>
				<% } %>
			</select>
			<% 
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			

			<br>
			<label for="seat_num"> Seat Number:</label>
			<input name="seat_num" id="seat_num" type="text" value="<% 
				tmp = seat_num != null? seat_num:"";
				out.print(tmp);
			%>">
			
			<!-- this is the class drop down box -->
			
			<br>
			<label for="seat_class"> Class:</label>
			<select name = "seat_class" id = "seat_class">
				<option value="economy"> Economy </option>
				<option value="business"> Business </option>
				<option value="first"> First </option>
			</select>
			
			<!-- this is the train number drop down box -->
			
			<br>
			<label for="train_num"> Train Number:</label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getMaxResID = "SELECT distinct f.train_id " 
						+ "FROM follows_a f ";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "train_num" id = "train_num">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("f.train_id")%></option>
				<% } %>
			</select>
			<% 
			}
			catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			%>
			
			<br>
			<br>
			<input type="submit" value="Update!">
		</form>

</body>
</html>

