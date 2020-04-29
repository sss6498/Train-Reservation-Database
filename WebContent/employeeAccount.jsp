<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Employee -- Group 31 Railway Booking</title>
	</head>
	<body>
		Hello, Employee!
		
		<br>
		
		<!-- Add Edit and Delete reservations of customers --> 
		<b><u> Add, Edit, and Delete Reservations</u></b>
		
		<br>
		
		<form method = 'post' action = employeeReservation.jsp>
			<label for = "reservationAction">Choose an action:</label>
			<select name = "reservationAction" id = "reservationAction">
				<option value="Create a Reservation"> Create a Reservation </option>
				<option value="Edit a Reservation"> Edit a Reservation </option>
				<option value="Delete a Reservation"> Delete a Reservation </option>
			</select>
			
			<br>
			
			<label for="resID"> Reservation ID Number: (Only if Editing or Deleting Reservation)</label>
			<input name="reservation_id" maxlength="30" id="reservation_id" type="text">
			
			<br>
			
			<input type="submit" value="Execute Action!"> 
			
		</form>
		
		<br>
		
		<b><u>Add, Edit, and Delete Train Schedule Information</u></b>
		
		<br>
		
		<form method = 'post' action = trainScheduleInfo.jsp>
			<label for = "trainInfoAction">Choose an action:</label>
			<select name = "trainInfoAction" id = "trainInfoAction">
				<option value="Add Train Info"> Add Information for Train Schedules </option>
				<option value="Edit Train Info"> Edit Information for Train Schedules </option>
				<option value="Delete Train Info"> Delete Information for Train Schedules </option>
			</select>
			
			<br>
			
			<label for="transit_line_name"> Train Line Name: </label>
			<%
			try {
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//getting the max res id of the reservations 
				String getLineNames = "SELECT distinct * " 
						+ "FROM train_schedule ";
				PreparedStatement getLineNamesQuery = conn.prepareStatement(getLineNames);
				ResultSet rs = getLineNamesQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "transit_line_name" id = "transit_line_name">
				<%  while(rs.next()){ %>
						<option><%= rs.getString("line_name")%></option>
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
			
			<label for="train_num"> Train Number: </label>
			<input name="train_num" maxlength="30" id="train_num" type="number">
			
			<br>
			 
			<input type="submit" value="Execute Action!"> 
			
		</form>
		
		<br>
		
		
		
	</body>
</html>