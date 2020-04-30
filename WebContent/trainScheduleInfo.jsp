<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedule Information -- Group 31 Railway Booking</title>
</head>
<body>


<% 
			String transit_line_name = null;
			String train = null;
			String origin = null;
			String destination = null;
			String available_num_of_seats = null;
			String stops = null;
			String departure = null;
			String departure_month = null;
			String departure_day = "01";
			String departure_year = "2020";
			String departure_hour = null;
			String departure_min = null;
			String arrival = null;
			String arrival_month = null;
			String arrival_day = "01";
			String arrival_year = "2020";
			String arrival_hour = null;
			String arrival_min = null;
			String fare = null;
			String num_stops = null;
			// ticketing prices
			String standard_oneway_price = null;
			String standard_roundtrip_price = null;
			String discounted_oneway_price = null;
			String discounted_roundtrip_price = null;
			String weekly_pass_price = null;
			String monthly_pass_price = null;
			
			
			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting action and ssn of admin
				String trainScheduleAction = request.getParameter("trainInfoAction");
				transit_line_name = request.getParameter("transit_line_name");
				train = request.getParameter("train_num");
				
				
				if (trainScheduleAction.equals("Add Train Info")){
					
					//throwing error if transit_line_name and train is blank
					if (transit_line_name.equals("") || train.equals("")){
						throw new Exception("Must provide Train Line Name & Train Number!");
					}
					
					//get number of seats
					String getSeatNum = "SELECT t.num_of_seats " 
								+ "FROM train t "
								+ "WHERE t.train_id=? ";
					PreparedStatement getSeatNumQuery = conn.prepareStatement(getSeatNum);
					getSeatNumQuery.setString(1, train);
					ResultSet rs1 = getSeatNumQuery.executeQuery();
					rs1.next();
					available_num_of_seats = rs1.getString("t.num_of_seats");
					getSeatNumQuery.close();
					
					String createFollowsAStr = "INSERT INTO follows_a() "
							+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
					PreparedStatement createFollowsAQuery = conn.prepareStatement(createFollowsAStr);
					createFollowsAQuery.setString(1, "0000-00-00");
					createFollowsAQuery.setString(2, "0000-00-00");
					createFollowsAQuery.setString(3, "0000-00-00");
					createFollowsAQuery.setString(4, "0");
					createFollowsAQuery.setString(5, train);
					createFollowsAQuery.setString(6, transit_line_name);
					createFollowsAQuery.setString(7, "0");
					createFollowsAQuery.setString(8, "0");
					try{
						createFollowsAQuery.executeUpdate();
					}catch(Exception e){
						request.setAttribute("status", "Sorry, a schedule for " + transit_line_name + " for Train Number " + train + " already exists.");
						RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
						rd.forward(request, response);
					}
					createFollowsAQuery.close();
					
					
				}else if (trainScheduleAction.equals("Edit Train Info")){
					
					//throwing error if transit_line_name and train is blank
					if (transit_line_name.equals("") || train.equals("")){
						throw new Exception("Must provide Train Line Name & Train Number!");
					}
					
					// need to make all values appear within the form of known fields 
					String getLine = "SELECT * " 
							+ "FROM follows_a f "
							+ "WHERE f.train_id = ? "
							+ "AND f.line_name = ?";
					PreparedStatement getLineQuery = conn.prepareStatement(getLine);
					getLineQuery.setString(1, train);
					getLineQuery.setString(2, transit_line_name);
					ResultSet rs = getLineQuery.executeQuery();
					
					//parsing results for reservation 
					rs.next();
					String origin_id =  rs.getString("origin_id");
					String destination_id = rs.getString("destination_id");
					available_num_of_seats = rs.getString("num_seats_available");
					departure = rs.getString("departure_time");
					arrival = rs.getString("arrival_time");
					rs.close();
					
					System.out.println("Origin id = " + origin_id);
					System.out.println("Destination id = " + destination_id);
					
					String getOrigin = "SELECT s.name " 
							+ "FROM station s "
							+ "WHERE s.station_id = ?";
					PreparedStatement getOriginQuery = conn.prepareStatement(getOrigin);
					getOriginQuery.setInt(1, Integer.parseInt(origin_id));
					ResultSet rs1 = getOriginQuery.executeQuery();
					rs1.next();
					origin = rs1.getString("name");
					rs1.close();
					
					
					
					String getDestination = "SELECT s.name " 
							+ "FROM station s "
							+ "WHERE s.station_id = ?";
					PreparedStatement getDestinationQuery = conn.prepareStatement(getDestination);
					getDestinationQuery.setString(1, destination_id);
					ResultSet rs2 = getDestinationQuery.executeQuery();
					rs2.next();
					destination = rs2.getString("name");
					rs2.close();
									
					
					String getStopsNum = "SELECT count(*) " 
							+ "FROM stops_at s "
							+ "WHERE s.train_id = ? "
							+ "AND s.line_name = ?";
					PreparedStatement getStopsNumQuery = conn.prepareStatement(getStopsNum);
					getStopsNumQuery.setString(1, train);
					getStopsNumQuery.setString(2, transit_line_name);
					ResultSet rs3 = getStopsNumQuery.executeQuery();
					rs3.next();
					num_stops = rs3.getString("count(*)");
					rs3.close();
					
					
					request.setAttribute("origin", origin);
					request.setAttribute("destination", destination);
					
					
					// delete all stops that this line name and train id have 
					String stopDeleteStr = "DELETE FROM stops_at "
							+ "WHERE stops_at.train_id=? "
							+ "AND stops_at.line_name=?";
					PreparedStatement stopDeleteQuery = conn.prepareStatement(stopDeleteStr);
					stopDeleteQuery.setString(1, train);
					stopDeleteQuery.setString(2, transit_line_name);
					stopDeleteQuery.executeUpdate();
			
					//get number of seats
					String getSeatNum = "SELECT t.num_of_seats " 
								+ "FROM train t "
								+ "WHERE t.train_id=? ";
					PreparedStatement getSeatNumQuery = conn.prepareStatement(getSeatNum);
					getSeatNumQuery.setString(1, train);
					ResultSet rs4 = getSeatNumQuery.executeQuery();
					rs4.next();
					available_num_of_seats = rs4.getString("t.num_of_seats");
					getSeatNumQuery.close();
							
					
				}else{
					//can just have query to delete account
					
					//throwing error if transit_line_name and train is blank
					if (transit_line_name.equals("") || train.equals("")){
						throw new Exception("Must provide Train Line Name & Train Number!");
					}
					
					// delete from follows_a
					String trainDeleteStr = "DELETE FROM follows_a "
					+ "WHERE follows_a.train_id=? "
					+ "AND follows_a.line_name=?";
					PreparedStatement trainDeleteQuery = conn.prepareStatement(trainDeleteStr);
					trainDeleteQuery.setString(1, train);
					trainDeleteQuery.setString(2, transit_line_name);
					trainDeleteQuery.executeUpdate();
					
					// delete from stops_at
					String stopDeleteStr = "DELETE FROM stops_at "
					+ "WHERE stops_at.train_id=? "
					+ "AND stops_at.line_name=?";
					PreparedStatement stopDeleteQuery = conn.prepareStatement(stopDeleteStr);
					stopDeleteQuery.setString(1, train);
					stopDeleteQuery.setString(2, transit_line_name);
					stopDeleteQuery.executeUpdate();
					
					//sending result to the adminActionStatus page
					request.setAttribute("status", "Delete Successful!");
					RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
					rd.forward(request, response);
					
					//closing everything
					trainDeleteQuery.close();
					stopDeleteQuery.close();
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
		
		<form method="post" action="processTrainScheduleUpdate.jsp">
		
			<label for="line_name"> Transit Line Name: </label>
			<input name="line_name" id="line_name" type="text" readonly = "readonly" value="<% out.print(transit_line_name); %>">
			<br>
			
			<label for="train_id"> Train Number: </label>
			<input name="train_id" id="train_id" type="text" readonly = "readonly" value="<% out.print(train); %>">
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
				String getMaxResID = "SELECT s.station_id, s.name " 
									+ "FROM station s ";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "origin" id = "origin">
				<%  while(rs.next()){ %>
						<% String id_value = rs.getString("s.station_id"); %>
						<% String value = rs.getString("s.name"); %>
						<% if (rs.getString("s.name").equals(origin)){
								out.print("<option selected value=" + id_value + ">" + value + "</option>");
							}else{
								out.print("<option value=" + id_value + ">" + value + "</option>");
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
				String getMaxResID = "SELECT s.station_id, s.name " 
									+ "FROM station s ";
				PreparedStatement getMaxResIDQuery = conn.prepareStatement(getMaxResID);
				ResultSet rs = getMaxResIDQuery.executeQuery();
				//parsing results for res id
			%>
				<select name = "destination" id = "destination">
				<%  while(rs.next()){ %>
						<% String id_value = rs.getString("s.station_id"); %>
						<% String value = rs.getString("s.name"); %>
						<% if (value.equals(destination)){
								out.print("<option selected value=" + id_value + ">" + value + "</option>");
							}else{
								out.print("<option value=" + id_value + ">" + value + "</option>");
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
			
			<!-- Departure Date and Time -->
		
			<label for="departure_time"> Departure Date & Time:</label>
			<br>
			<label for="departure_month"> Month: </label>
			<select name = "departure_month" id = "departure_month">
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
			<input name="departure_day" id="departure_day" type="text" value="<% out.print(departure_day); %>">
			<label for="departure_year"> Year: </label>
			<input name="departure_year" id="departure_year" type="text" value="<% out.print(departure_year); %>">
			<label for="departure_hour"> Hour: </label>
			<select name = "departure_hour" id = "departure_hour">
				<%  for(int i=0; i<24; i++) { %>
						<option><%= new DecimalFormat("00").format(i) %></option>
				<% } %>
			</select>
			<label for="departure_min"> Minute: </label>
			<select name = "departure_min" id = "departure_min">
				<%  for(int i=0; i<60; i++) { %>
						<option><%= new DecimalFormat("00").format(i) %></option>
				<% } %>
			</select>
			<br>
			
			<!-- Arrival Date and Time -->
			
			<label for="arrival_time"> Arrival Date & Time:</label>
			<br>
			<label for="arrival_month"> Month: </label>
			<select name = "arrival_month" id = "arrival_month">
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
			<input name="arrival_day" id="arrival_day" type="text" value="<% out.print(arrival_day); %>">
			<label for="arrival_year"> Year: </label>
			<input name="arrival_year" id="arrival_year" type="text" value="<% out.print(arrival_year); %>">
			<label for="arrival_hour"> Hour: </label>
			<select name = "arrival_hour" id = "arrival_hour">
				<%  for(int i=0; i<24; i++) { %>
						<option><%= new DecimalFormat("00").format(i) %></option>
				<% } %>
			</select>
			<label for="arrival_min"> Minute: </label>
			<select name = "arrival_min" id = "arrival_min">
				<%  for(int i=0; i<60; i++) { %>
						<option><%= new DecimalFormat("00").format(i) %></option>
				<% } %>
			</select>
			<br>
			<label for="num_stops"> How many stops will there be?  </label>
			<input name="num_stops" id="num_stops" type="number" value="<% out.print(num_stops); %>">
			<br>
			
			<!-- Input for Ticketing Prices -->
			
			<label for="ticketing_options"> What types of ticketing options would like to be included?  </label>
			<br>
			<label for="ticketing_options_instructions"> Instructions: Mark checkbox to include this type of fare. Insert fare price in box. </label>
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="Standard_OneWay"> Standard - One Way 
			<input name="standard_oneway_price" id="standard_oneway_price" type="number" value="<% out.print(standard_oneway_price); %>">
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="Standard_RoundTrip"> Standard - Round Trip 
			<input name="standard_roundtrip_price" id="standard_roundtrip_price" type="number" value="<% out.print(standard_roundtrip_price); %>">
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="Discounted_OneWay"> Discounted - One Way 
			<input name="discounted_oneway_price" id="discounted_oneway_price" type="number" value="<% out.print(discounted_oneway_price); %>">
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="Discounted_RoundTrip"> Discounted - Round Trip 
			<input name="discounted_roundtrip_price" id="discounted_roundtrip_price" type="number" value="<% out.print(discounted_roundtrip_price); %>">
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="WeeklyPass"> Weekly Pass 
			<input name="weekly_pass_price" id="weekly_pass_price" type="number" value="<% out.print(weekly_pass_price); %>">
			<br>
			<input name="ticketing_options" id="ticketing_options" type="checkbox" value="MonthlyPass"> Monthly Pass 
			<input name="monthly_pass_price" id="monthly_pass_price" type="number" value="<% out.print(monthly_pass_price); %>">
			
			
			<br>
			<br>
			<input type="submit" value="Update!">
		</form>	

</body>
</html>