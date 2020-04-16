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
				//reading in old and new parameters
				String oldEmpSsn = session.getAttribute("empSsn").toString();
				Object oldEmpUsernameObj = session.getAttribute("empUsername");
				String empSsn = request.getParameter("empSSN");
				String empFirstName = request.getParameter("empFirstName");
				String empLastName = request.getParameter("empLastName");
				String empUsername = request.getParameter("empAccountUsername");
				String empPassword = request.getParameter("empAccountPassword");
				
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//make sure account is given username and password
				if (empUsername.equals("")){
					throw new Exception("Username cannot be blank!");
				}
				
				//checking to make sure ssn is of proper length
				if (empSsn.equals("") || empSsn.length() != 9){
					throw new Exception("SSN must be of length 9!");
				}
				
				//updating account username
				String updateEmpAccStr = "UPDATE account a "
						+ "SET a.username=?, "
						+ "a.password=? "
						+ "WHERE a.username=?";
						
				PreparedStatement updateEmpAccQuery = conn.prepareStatement(updateEmpAccStr);
				updateEmpAccQuery.setString(1, empUsername);
				updateEmpAccQuery.setString(2, empPassword);
				updateEmpAccQuery.setString(3, oldEmpUsername);
				updateEmpAccQuery.executeUpdate();
				updateEmpAccQuery.close();
				
				//updating employee info
				String alterEmpInfoStr = "UPDATE employee e "
						+ "SET e.ssn=?, "
						+ "e.name_first=?, "
						+ "e.name_last=? "
						+ "WHERE e.ssn=?";
				PreparedStatement alterEmpInfoQuery = conn.prepareStatement(alterEmpInfoStr);
				alterEmpInfoQuery.setString(1, empSsn);
				
				if (empFirstName.equals("")){
					alterEmpInfoQuery.setNull(2, java.sql.Types.VARCHAR);
				}else{
					alterEmpInfoQuery.setString(2, empFirstName);
				}
				
				if (empLastName.equals("")){
					alterEmpInfoQuery.setNull(3, java.sql.Types.VARCHAR);
				}else{
					alterEmpInfoQuery.setString(3, empLastName);
				}
				
				alterEmpInfoQuery.setString(4, oldEmpSsn);
				alterEmpInfoQuery.executeUpdate();
				
				//updating session variables
				session.setAttribute("empSsn", empSsn);
				session.setAttribute("empUsername", empUsername);
				
				request.setAttribute("status", "Successful!");
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
				
				//closing connections
				alterEmpInfoQuery.close();
				conn.close();
				
			} catch (Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
			}
		
		%>
	</body>
</html>