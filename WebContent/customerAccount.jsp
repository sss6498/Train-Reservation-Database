<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Customer Account -- Group 31 Railway Booking</title>
	</head>
	<body>
		Welcome, 
		<% 
			String username = request.getParameter("username");
			out.print(username);
		%>
		
		<br>
		
		<form method=get action=index.jsp>
			<input type="submit" value="Logout!">
		</form>
		
	</body>
</html>