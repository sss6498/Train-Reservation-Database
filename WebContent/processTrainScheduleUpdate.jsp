<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Process Train Schedule Update -- Group 31 Railway Booking</title>
</head>
<body>


	<%
	
			//reading in parameters 
			String transit_line_name = request.getParameter("line_name");
			String train = request.getParameter("train_id");
			String origin_id = request.getParameter("origin");
			String destination_id = request.getParameter("destination");
			String departure = null;
			String departure_month = request.getParameter("departure_month");
			String departure_day = request.getParameter("departure_day");
			String departure_year = request.getParameter("departure_year");
			String departure_hour = request.getParameter("departure_hour");
			String departure_min = request.getParameter("departure_min");
			String arrival = null;
			String arrival_month = request.getParameter("arrival_month");
			String arrival_day = request.getParameter("arrival_day");
			String arrival_year = request.getParameter("arrival_year");
			String arrival_hour = request.getParameter("arrival_hour");
			String arrival_min = request.getParameter("arrival_min");
			String fare = null;
			String num_seats_available = null;
			String num_stops_str = request.getParameter("num_stops");
	
			try {
				
				// combine departure and arrival parts to datetime 
				departure = departure_year.trim() 
							+ "-" + departure_month.trim() 
							+ "-" + departure_day.trim() 
							+ " " + departure_hour.trim()
							+ ":" + departure_min.trim();
				
				arrival = arrival_year.trim() 
						+ "-" + arrival_month.trim() 
						+ "-" + arrival_day.trim() 
						+ " " + arrival_hour.trim()
						+ ":" + arrival_min.trim();
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
				java.util.Date departure_date = sdf.parse(departure);
				java.util.Date arrival_date = sdf.parse(arrival);
			    long diff = arrival_date.getTime() - departure_date.getTime();
			    long diffMins = diff/ (60*1000) % 60; 
			    long diffHours = diff/ (60*60*1000) % 60;
			    String travel_time_str = "0000-00-00 " + diffHours + ":" + diffMins;
			    //SimpleDateFormat sdf2 = new SimpleDateFormat("hh:mm");
			    //java.util.Date travel_time = sdf2.parse(travel_time_str);
			    
				
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				// retrieve the number of seats
				String getNumSeats = "SELECT t.num_of_seats " 
							+ "FROM train t "
							+ "WHERE t.train_id = ?";
				PreparedStatement getNumSeatsQuery = conn.prepareStatement(getNumSeats);
				getNumSeatsQuery.setString(1, train);
				ResultSet rs1 = getNumSeatsQuery.executeQuery();
				rs1.next();
				num_seats_available = rs1.getString("t.num_of_seats");
				rs1.close();
				
				//updating reservation row
				String updateFollowsAStr = "UPDATE follows_a f "
						+ "SET f.departure_time=?, "
						+ "f.arrival_time=?, "
						+ "f.travel_time=?, "
						+ "f.num_seats_available=?, "
						+ "f.origin_id=?, "
						+ "f.destination_id=? "
						+ "WHERE f.train_id=? "
						+ "AND f.line_name=?";
				
				PreparedStatement updateFollowsAQuery = conn.prepareStatement(updateFollowsAStr);
				updateFollowsAQuery.setString(1, "" + departure);
				updateFollowsAQuery.setString(2, "" + arrival);
				updateFollowsAQuery.setString(3, "" + travel_time_str);
				updateFollowsAQuery.setString(4, num_seats_available);
				updateFollowsAQuery.setString(5, origin_id);
				updateFollowsAQuery.setString(6, destination_id);
				updateFollowsAQuery.setString(7, train);
				updateFollowsAQuery.setString(8, transit_line_name);
				updateFollowsAQuery.executeUpdate();
				updateFollowsAQuery.close();
				
				
				// need to add fare prices to the fare table 
				String createFareStr = null;
				// figure out what we received from the form 
				String[] checkedBoxes = request.getParameterValues("ticketing_options");
				
				// delete from fare
				String fareDeleteStr = "DELETE FROM fare "
				+ "WHERE fare.train_id=? "
				+ "AND fare.line_name=?";
				PreparedStatement fareDeleteQuery = conn.prepareStatement(fareDeleteStr);
				fareDeleteQuery.setString(1, train);
				fareDeleteQuery.setString(2, transit_line_name);
				fareDeleteQuery.executeUpdate();
				fareDeleteQuery.close();
				
				for(int i=0; i < checkedBoxes.length; i++){
					createFareStr = "INSERT INTO fare() "
							+ "VALUES (?, ?, ?, ?)";
					PreparedStatement insertFareQuery = conn.prepareStatement(createFareStr);
					if (checkedBoxes[i].equals("Standard_OneWay")){
						insertFareQuery.setString(1, "standard_oneway");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("standard_oneway_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();
					}else if (checkedBoxes[i].equals("Standard_RoundTrip")){
						insertFareQuery.setString(1, "standard_roundtrip");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("standard_roundtrip_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();
					}else if (checkedBoxes[i].equals("Discounted_OneWay")){
						insertFareQuery.setString(1, "discounted_oneway");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("discounted_oneway_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();
					}else if (checkedBoxes[i].equals("Discounted_RoundTrip")){
						insertFareQuery.setString(1, "discounted_roundtrip");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("discounted_roundtrip_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();
					}else if (checkedBoxes[i].equals("WeeklyPass")){
						insertFareQuery.setString(1, "weeklypass");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("weekly_pass_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();
					}else { // this is for the MonthlyPass checked box 
						insertFareQuery.setString(1, "monthlypass");
						insertFareQuery.setString(2, transit_line_name);
						insertFareQuery.setString(3, train);
						insertFareQuery.setString(4, request.getParameter("monthly_pass_price"));
						insertFareQuery.executeUpdate();
						insertFareQuery.close();	
					}
				}
				
				conn.close();
				
			} catch (Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
				rd.forward(request, response);
			}
		
		%>
		
		<!-- need to set up dynamic form for number of stops  -->
		
		
		
		
		<b><u> Fill out the form below and press submit to continue!</u></b>
		
		<br>
		<br>
		
		<form method="post" action="processStopUpdate.jsp">
		
			<label for="line_name"> Transit Line Name: </label>
			<input name="line_name" id="line_name" type="text" readonly = "readonly" value="<% out.print(transit_line_name); %>">
			<br>
			
			<label for="train_id"> Train Number: </label>
			<input name="train_id" id="train_id" type="text" readonly = "readonly" value="<% out.print(train); %>">
			<br>
			<label for="stop_num"> Number of Stops: </label>
			<input name="stop_num" id="stop_num" type="text" readonly = "readonly" value="<% out.print(num_stops_str); %>">
			<br>
			<br>
			<br>
		<%
			int num_stops = Integer.parseInt(num_stops_str);
			for (int i=1; i<num_stops+1; i++) { 
		%>
		
				<% out.print("<label for=" + "Stop" + i + "> Stop " + i + ":</label>"); %>
				<%
				try {
					//The url of our database
					String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
					
					Class.forName("com.mysql.jdbc.Driver");
					
					//Attempting to make a connection to database
					Connection conn = DriverManager.getConnection(url, "group31", "database20");
					
					//getting the max res id of the reservations 
					String getMaxResID = "SELECT s.station_id, s.name " 
							+ "FROM station s;";
					PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
					ResultSet rs = getMaxResIDQuery.executeQuery();
					//parsing results for res id
				%>
					<% out.print("<select name=stop" + i + " id=stop" + i + ">"); %>
					<% while(rs.next()){ %>
							<% String id_value = rs.getString("s.station_id"); %>
							<% String value = rs.getString("s.name"); %>
							<% if (!id_value.equals(origin_id) && !id_value.equals(destination_id)){
									out.print("<option value=" + id_value + ">" + value + "</option>");
								}
						} %>
				<% out.print("</select>"); %>
				
				<!-- Arrival Time Location -->
				<br>
				<% out.print("<label for=arrival_time" + i + "> Arrival " + i + " Date & Time: </label>"); %>
				<br>
				<label for="arrival_month"> Month: </label>
				<% out.print("<select name=arrival_month" + i + " id=arrival_month" + i + ">"); %>
					<option value="01"> Jan </option>
					<option value="02"> Feb </option>
					<option value="03"> Mar </option>
					<option value="04"> Apr </option>
					<option value="05"> May </option>
					<option value="06"> Jun </option>
					<option value="07"> Jul </option>
					<option value="08"> Aug </option>
					<option value="09"> Sep </option>
					<option value="10"> Oct </option>
					<option value="11"> Nov </option>
					<option value="12"> Dec </option>
				</select>
				<label for="arrival_day"> Day: </label>
				<% out.print("<input name=arrival_day" + i + " id=arrival_day" + i + " maxlength=2 type=text>"); %>
				<label for="arrival_year"> Year: </label>
				<% out.print("<input name=arrival_year" + i + " id=arrival_year" + i + " maxlength=4 type=text>"); %>
				<label for="arrival_hour"> Hour: </label>
				<% out.print("<select name=arrival_hour" + i + " id=arrival_hour" + i + ">"); %>
					<%  for(int j=0; j<24; j++) { %>
							<option><%= new DecimalFormat("00").format(j) %></option>
					<% } %>
				</select>
				<label for="arrival_min"> Minute: </label>
				<% out.print("<select name=arrival_min" + i + " id=arrival_min" + i + ">"); %>
					<%  for(int k=0; k<60; k++) { %>
							<option><%= new DecimalFormat("00").format(k) %></option>
					<% } %>
				</select>
				
				
				<br>
		
				<!-- Departure Time Location -->
		
				<% out.print("<label for=departure_time" + i + "> Departure " + i + " Date & Time: </label>"); %>
				<br>
				<label for="departure_month"> Month: </label>
				<% out.print("<select name=departure_month" + i + " id=departure_month" + i + ">"); %>
					<option value="01"> Jan </option>
					<option value="02"> Feb </option>
					<option value="03"> Mar </option>
					<option value="04"> Apr </option>
					<option value="05"> May </option>
					<option value="06"> Jun </option>
					<option value="07"> Jul </option>
					<option value="08"> Aug </option>
					<option value="09"> Sep </option>
					<option value="10"> Oct </option>
					<option value="11"> Nov </option>
					<option value="12"> Dec </option>
				</select>
				<label for="departure_day"> Day: </label>
				<% out.print("<input name=departure_day" + i + " id=departure_day" + i + " maxlength=2 type=text>"); %>
				<label for="departure_year"> Year: </label>
				<% out.print("<input name=departure_year" + i + " id=departure_year" + i + " maxlength=4 type=text>"); %>
				<label for="arrival_hour"> Hour: </label>
				<% out.print("<select name=departure_hour" + i + " id=departure_hour" + i + ">"); %>
					<%  for(int j=0; j<24; j++) { %>
							<option><%= new DecimalFormat("00").format(j) %></option>
					<% } %>
				</select>
				<label for="arrival_min"> Minute: </label>
				<% out.print("<select name=departure_min" + i + " id=departure_min" + i + ">"); %>
					<%  for(int k=0; k<60; k++) { %>
							<option><%= new DecimalFormat("00").format(k) %></option>
					<% } %>
				</select>
				
				<% 
				conn.close();
				} catch(Exception e){
					request.setAttribute("status", e.getMessage());
					RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
					rd.forward(request, response);
				}
				%>
				<br>
				<br>
				
		<%		
			} // end of the for loop 
		%>
		
			<br>
			<input type="submit" value="Update!">
		
		
		</form>


</body>
</html>