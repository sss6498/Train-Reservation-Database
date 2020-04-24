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
						
				String resHistLookupStr = "SELECT r.reservation_id, r.date, r.class, r.seat_num, r.booking_fee "
						+ "FROM reservation r "
						+ "WHERE r.username = ?;";

				PreparedStatement scheduleLookupQuery = conn.prepareStatement(resHistLookupStr);
				
				scheduleLookupQuery.setString(1, username);
				
				//Executing the query
				ResultSet rs = scheduleLookupQuery.executeQuery();
				
				//Parsing results
   				/*ResultSetMetaData rsmd = rs.getMetaData();
  				int columnsNumber = rsmd.getColumnCount();
   				while (rs.next()) {
       			for (int i = 1; i <= columnsNumber; i++) {
          			if (i > 1) out.print(",  ");
           			String columnValue = rs.getString(i);
           			out.print(columnValue + " " + rsmd.getColumnName(i));
      			}
       			System.out.println("");*/
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
						out.println("<TD>" + rs.getString(i + 1) + "</TD>");
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