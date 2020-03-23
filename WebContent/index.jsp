<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Group 31 Railway Booking</title>
	</head>
	<body>
		<b>
		Welcome to the Group 31's Railway Booking System
		</b>
		<br>
		<br>
		<u>
		Login:
		</u>
		
		<!-- Login -->
		<form method="post" action="account.jsp">
			<label for="unameLogin"> Username: </label>
			<input name="username" id="unameLogin" type="text">
			<br>
			<label for="passLogin"> Password: </label>
			<input name="password" id="passLogin" type="text">
			<br>
			<input type="submit" value="Submit!">
		</form>
		
		<br>
		<br>
		If you do not have an account, create one here:
		<br>
		
		<!-- If no account setup, create one -->
		<form method="post" action="accountCreated.jsp">
			<label for="unameCreate"> Username: </label>
			<input name="username" id="unameCreate" type="text">
			<br>
			<label for="passCreate"> Password: </label>
			<input name="password" id="passCreate" type="text">
			<br>
			<input type="submit" value="Create Account!">
		</form>
	</body>
</html>