<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Status -- Group 31 Railway Booking System</title>
	</head>
	<body>
		<%
			out.print(request.getAttribute("status"));
		%>
	</body>
</html>