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
		<form method=get action=searchQuestion.jsp>
			<label for="searchQuestion"> Search for a Question: </label>
			<input name="search" id="searchQuestion" type="text">
			<input type="submit" value="Search!">
		</form>
	<br>
	<br>
	<b>Browse Questions and Answers:</b>
	
	<%
	    
		try {
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
		
			
			Statement stmt = conn.createStatement();

			String str = "SELECT * FROM question";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

		
			out.print("<tr>");
			out.print("<td>");
			
			out.print("Question");
			out.print("</td>");
			out.print("<td>");
			out.print("Answer");
			out.print("</td>");
			out.print("<td>");
			out.print("Submitted By");
			out.print("</td>");

			
			while (result.next()) {
				
				out.print("<tr>");
				
				out.print("<td>");
				
				out.print(result.getString("question"));
				out.print("</td>");
				out.print("<td>");
				
				out.print(result.getString("answer"));
				out.print("</td>");
				out.print("<td>");
				
				out.print(result.getString("name_first"));
				out.print(" ");
				out.print(result.getString("name_last"));
				out.print("</td>");


			}
			out.print("</table>");

			conn.close();
		} catch (Exception e) {
			out.print(e);
		}
	%>

	</body>
</html>