<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Reservation History</title>
</head>
<body>
All your past and current train reservations are listed below

<%
			//Getting selections from customerAccount.jsp
			String username = request.getParameter("username");

			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
						
				String resHistLookupStr = "SELECT r.reservation_id AS 'Reservation ID', r.class AS Class, r.seat_num AS 'Seat Number', "
						+ "r.booking_fee AS 'Booking Fee', r.total_fare AS 'Fare', f.line_name AS 'Line', f.departure_time AS 'Departure Time', "
						+ "f.arrival_time AS 'Arrival Time', s.name AS 'Departure Station', x.name AS 'Arrival Station' "
						+ "FROM reservation r, follows_a f, made_for m, station s, station x "
						+ "WHERE r.username = ? and r.reservation_id = m.reservation_id and m.train_id = f.train_id and m.line_name = f.line_name and s.station_id = f.origin_id and x.station_id = f.destination_id;";

				PreparedStatement scheduleLookupQuery = conn.prepareStatement(resHistLookupStr);
				
				scheduleLookupQuery.setString(1, username);
				//scheduleLookupQuery.setString(2, username);
				
				//Executing the query
				ResultSet rs = scheduleLookupQuery.executeQuery();
				
				int rowCount = 0;
				out.println("<P ALIGN='center'><TABLE BORDER=1>");
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				// table header
				out.println("<TR>");
				for (int i = 0; i < columnCount; i++) {
					out.println("<TH>" + rsmd.getColumnLabel(i + 1) + "</TH>");
				}
				out.println("</TR>");
				// the data
				while (rs.next()) {
					rowCount++;
					out.println("<TR>");
					for (int i = 0; i < columnCount; i++) {
						String temp = rs.getString(i + 1);
						if (i == 3) {
								if (temp.equals("discounted_oneway"))
									temp = "Oneway Discounted";
								else if (temp.equals("discounted_roundtrip"))
									temp = "Roundtrip Discounted";
								else if (temp.equals("monthlypass"))
									temp = "Monthly Pass";
								else if (temp.equals("standard_oneway"))
									temp = "Oneway Standard";
								else if (temp.equals("standard_roundtrip"))
									temp = "Roundtrip Standard";
								else if (temp.equals("weeklypass"))
									temp = "Weekly Pass";
							}
						out.println("<TD>" + temp + "</TD>");
				    }
					out.println("</TR>");
				}
				out.println("</TABLE></P>");
								
				//closing all objects
				rs.close();
				scheduleLookupQuery.close();
				conn.close();
				
			}catch(Exception e){
				out.print(e);
				out.print("<br>");
				out.print("Sorry, the reservations you're looking for don't exist.");
			}
		%>
		
		<br>
		If you would like to cancel one of these reservations, please input the reservation id into the box below and click 'cancel'
		<form action="customerCancelReservation.jsp">
		<label for="date">ID of reservation you would like to cancel:</label>
		  <input type="text" id="reservation_id" name="reservation_id">
		<input type="hidden" id="username" name="username" value=<%=username%>>
		<input type="submit" value="Cancel">
		</form>
</body>
</html>