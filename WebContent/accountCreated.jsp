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
		<%
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting username and pass from index.jsp
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				
				//Don't allow blank usernames
				if (username.equals("")){
					throw new Exception("Username cannot be blank!");
				}
				
				//Looking up the account in the database
				String insertAccountInfoStr = "INSERT INTO account (username, password) "
										+ "VALUES (?, ?)";
				
				PreparedStatement insertAccountInfoQuery = conn.prepareStatement(insertAccountInfoStr);
				
				insertAccountInfoQuery.setString(1, username);
				insertAccountInfoQuery.setString(2, password);
				
				insertAccountInfoQuery.executeUpdate();
				
				out.println("Account created, " + username + "!");
				
				//closing all objects
				insertAccountInfoQuery.close();
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Your account was unable to be created.");
			}
		%>
	</body>
</html>