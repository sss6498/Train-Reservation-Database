<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Admin -- Group 31 Railway Booking</title>
	</head>
	<body>
		Welcome, Administrator!
		
		<br>
		<br>
		
		<b><u> Best 5 Customers!</u></b>
		<!--  Logic needs to be inserted-->
		
		<br>
		<br>
		
		<b><u> Top 5 Most Active Transit Lines!</u></b>
		<!--  Logic needs to be inserted-->
		
		<br>
		<br>
	
		<!-- Add, Edit, Delete Fields for Employee -->
		<b><u> Add, Edit, or Delete Information for an Employee</u></b>
		
		<br>
		
		<form method="post" action="employeeInfo.jsp">
			<label for="ssn"> SSN: (without dashes)</label>
			<input name="ssn" maxlength="9" id="ssn" type="text">
			<br>
			<input type="submit" value="Find Employee!">
		</form>
		
		<br>
		
		<!-- Add, Edit, Delete Fields for Customer -->
		<b><u> Add, Edit, or Delete Information for an Customer</u></b>
		<br>
		<form method="post" action="customerInfo.jsp">
			<label for="custFirstName"> First Name: </label>
			<input name="custFirstName" id="custFirstName" type="text">
			<br>
			<label for="custLastName"> Last Name: </label>
			<input name="custLastName" id="custLastName" type="text">
			<br>
			<label for="custEmail"> Email:  </label>
			<input name="custEmail" id="custEmail" type="text">
			<br>
			<input type="submit" value="Find Customer!">
		</form>
		
		<br>
		
		<b><u> View Monthly Sales Reports</u></b>
		<br>
		<form method="post" action="salesReport.jsp">
			<label for="salesMonth"> Month: </label>
			<input name="salesMonth" id="salesMonth" type="text">
			<br>
			<input type="submit" value="Submit!">
		</form>
		
		<br>
		
		<b><u> Find Reservations: </u></b>
		<br>
		<form method="post" action="findReservations.jsp">
			<label for="trainLineRes"> Train Line Name: </label>
			<input name="trainLineRes" id="trainLineRes" type="text">
			<br>
			<label for="trainNumberRes"> Train Number: </label>
			<input name="trainNumberRes" id="trainNumberRes" maxlength="4" type="text">
			<br>
			<input type="submit" value="Find Reservations!">
		</form>
		
		<br>
		
		<u> OR USE: </u>
		
		<br>
		<br>
		
		<form method="post" action="listReservations.jsp">
			<label for="resFirst"> Customer First Name: </label>
			<input name="resFirst" id="resFirst" type="text">
			<br>
			<label for="resLast"> Customer Last Name: </label>
			<input name="resLast" id="resLast" type="text">
			<br>
			<label for="resEmail"> Email:  </label>
			<input name="resEmail" id="resEmail" type="text">
			<br>
			<input type="submit" value="Find Reservations!">
		</form>
		
		<br>
		
		<b><u> Determine Revenue Per: </u></b>
		<form method="post" action="listRevenues.jsp">
			<label for="trainLineRev"> Train Line Name: </label>
			<input name="trainLineRev" id="trainLineRev" type="text">
			<br>
			<input type="submit" value="List Revenues!">
		</form>
		
		<br>
		<u> OR USE: </u>
		<br>
		<br>
		
		<form method="post" action="listRevenues.jsp">
			<label for="destCityRev"> Destination City: </label>
			<input name="destCityRev" id="destCityRev" type="text">
			<br>
			<input type="submit" value="List Revenues!">
		</form>
		
		<br>
		<u> OR USE: </u>
		<br>
		<br>
		
		<form method="post" action="listRevenues.jsp">
			<label for="revFirst"> Customer First Name: </label>
			<input name="revFirst" id="revFirst" type="text">
			<br>
			<label for="revLast"> Customer Last Name: </label>
			<input name="revLast" id="revLast" type="text">
			<br>
			<label for="revEmail"> Customer Email: </label>
			<input name="revEmail" id="revEmail" type="text">
			<br>
			<input type="submit" value="List Revenues!">
		</form>
		
	</body>
</html>