<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee - Customers with Reserved Seats -- Group 31 Railway Booking</title>
</head>
<body>

<% 
		String line_name = request.getParameter("transit_line_name");
		String train_id = request.getParameter("train_num");
		String name_first = null;
		String name_last = null;
		String username = null;
		String seat_num = null;
	
		try{
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
		
			String getData = "SELECT c.name_first, c.name_last, c.username, t1.seat_num " 
					+ "FROM (SELECT r.username, r.seat_num  "
					+ "FROM made_for m, reservation r "
					+ "WHERE m.train_id = ? "
					+ "AND m.line_name = ? "
					+ "AND m.reservation_id = r.reservation_id) t1, "
					+ "customer c "
					+ "WHERE t1.username = c.username ";
			
			PreparedStatement getDataQuery = conn.prepareStatement(getData);
			getDataQuery.setString(1, train_id);
			getDataQuery.setString(2, line_name);
			ResultSet rs = getDataQuery.executeQuery();
			
			out.println("<br>");
			
			out.print("<TABLE BORDER=1>");
			out.print("<TR>");
			out.print("<TH>First Name </TH>");
			out.print("<TH>Last Name </TH>");
			out.print("<TH>Username</TH>");
			out.print("<TH>Seat Number</TH>");
			out.print("</TR>");
			
			
			while(rs.next() != false) {
				name_first = rs.getString("c.name_first");
				name_last = rs.getString("c.name_last");
				username = rs.getString("c.username");
				seat_num = rs.getString("t1.seat_num");
				
				out.print("<TR>");
				out.print("<TD>" + name_first + "</TH>");
				out.print("<TD>" + name_last + "</TH>");
				out.print("<TD>" + username + "</TH>");
				out.print("<TD>" + seat_num + "</TH>");
				out.print("</TR>");
				
			}
			
			out.print("</TABLE>");
			
			rs.close();
	
		}
		catch (Exception e) {
			request.setAttribute("status", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("/employeeActionStatus.jsp");
			rd.forward(request, response);
			
		}
	
	%>
	
	<br>
	<br>
	
	<form method="post" action="employeeAccount.jsp">
			<input type="submit" value="Go back to Account!">
		</form>

</body>
</html>