<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Employee Action Status -- Group 31 Railway Booking</title>
</head>
<body>

<%
			out.print(request.getAttribute("status"));
		%>
		
		<br>
		<br>
		
		<form method="post" action="employeeAccount.jsp">
			<input type="submit" value="Go back to Account!">
		</form>

</body>
</html>