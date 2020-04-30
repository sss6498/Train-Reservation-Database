<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Reservation editing 2 extra -- Group 31 Railway Booking</title>
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
				booking_fee = request.getParameter("booking_fee");
				seat_class = request.getParameter("seat_class");
				departure = request.getParameter("departure_time");
				
				
				// need to get the train number using the departure time and transit line name 
				String getTrain = "SELECT f.train_id " 
							+ "FROM follows_a f "
							+ "WHERE f.line_name=? "
							+ "AND f.departure_time=? ";
				PreparedStatement getTrainQuery = conn.prepareStatement(getTrain);
				getTrainQuery.setString(1, transit_line);
				getTrainQuery.setString(2, departure);
				ResultSet rsTrain = getTrainQuery.executeQuery();
				rsTrain.next();
				train_num = rsTrain.getString("f.train_id");
				
				
				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
			
			// add in fields to edit below 
			
		%>



		<b><u> Fill out Purchase Type and press continue!</u></b>
			
		<br>
		<br>
		
		<form method="post" action="employeeReservation3.jsp">
		
		
			<label for="purchase_type"> Purchase Type: </label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				String getPurchaseTypes = "SELECT f.type " 
						+ "FROM fare f "
						+ "WHERE f.train_id=? "
						+ "AND f.line_name=?";
				PreparedStatement getPurchaseTypesQuery = conn.prepareStatement(getPurchaseTypes);
				getPurchaseTypesQuery.setString(1, train_num);
				getPurchaseTypesQuery.setString(2, transit_line);
				ResultSet rs = getPurchaseTypesQuery.executeQuery();
			%>
				<select name = "purchase_type" id = "purchase_type">
				<%  while(rs.next()){ %>
					<%	
						pt_val = rs.getString("f.type");
						if (pt_val.equals("standard_oneway")){
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Standard - One Way" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Standard - One Way" + "</option>");
							}
						}else if (pt_val.equals("standard_roundtrip")){
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Standard - Round Trip" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Standard - Round Trip" + "</option>");
							}
						}else if (pt_val.equals("discounted_oneway")){
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Discounted - One Way" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Discounted - One Way" + "</option>");
							}
						}else if (pt_val.equals("discounted_roundtrip")){
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Discounted - Round Trip" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Discounted - Round Trip" + "</option>");
							}
						}else if (pt_val.equals("weeklypass")){
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Weekly Pass" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Weekly Pass" + "</option>");
							}
						}else { // this is monthlypass
							if (pt_val.equals(purchase_type)){
								out.print("<option selected value=" + pt_val + ">" + "Monthly Pass" + "</option>");
							}else {
								out.print("<option value=" + pt_val + ">" + "Monthly Pass" + "</option>");
							}
						}	
					%>
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
			
			<label for="train_id"> Transit Line:</label>
			<input name="train_id" id="train_id" type="text" readonly = "readonly" value="<% out.print(train_num); %>">
			<br>
			
			<label for="departure_time"> Departure Time:</label>
			<input name="departure_time" id="departure_time" type="text" readonly = "readonly" value="<% out.print(departure); %>">
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