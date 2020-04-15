<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Employee Info Update -- Group 31 Railway Booking</title>
	</head>
	<body>
		<%
			try {
				String oldSsn = session.getAttribute("empSsn").toString();
				String empSsn = request.getParameter("empSSN");
				String empFirstName = request.getParameter("empFirstName");
				String empLastName = request.getParameter("empLastName");
				String empUsername = request.getParameter("empAccountUsername");
				String empPassword = request.getParameter("empAccountPassword");
				
				//checking to make sure ssn is of proper length
				if (empSsn.equals("") || empSsn.length() != 9){
					throw new Exception("SSN must be of length 9!");
				}
				
				//update the account first hen update employee info
				
				String alterEmpInfoStr = "UPDATE employee e "
						+ "SET e.ssn=? "
						+ "SET e.name_first=? "
						+ "SET e.name_last=? "
						+ "SET e.username=? "
						+ "WHERE e.ssn=?";
				
				
			} catch (Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
			}
		
		%>
	</body>
</html>