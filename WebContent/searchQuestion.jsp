<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>    
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Group 31 Railway Booking</title>
	</head>
	
	
	<body>
	<button type="button" name="back" onclick="history.back()">Back</button>
	<br>
	<br>
	<b>Results:</b>
	<%
	    
		try {
			//The url of our databse
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
		
			
			Statement stmt = conn.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			String entity = request.getParameter("search");
			String entity1 = "'%" + entity + "%'";
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT * FROM question where question LIKE " + entity1;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Question");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Answer");
			out.print("</td>");
			out.print("<td>");
			out.print("Submitted By");
			out.print("</td>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current bar or beer name:
				out.print(result.getString("question"));
				out.print("</td>");
				out.print("<td>");
				//Print out current bar/beer additional info: Manf or Address
				out.print(result.getString("answer"));
				out.print("</td>");
				out.print("<td>");
				//Print out current bar/beer additional info: Manf or Address
				out.print(result.getString("name_first"));
				out.print(" ");
				out.print(result.getString("name_last"));
				out.print("</td>");

			}
			out.print("</table>");

			//close the connection.
			conn.close();
		} catch (Exception e) {
			out.print(e);
		}
	%>

	</body>
</html>