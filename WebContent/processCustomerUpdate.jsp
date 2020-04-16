<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Customer Info Update -- Group 31 Railway Booking</title>
	</head>
	<body>
		<%
			try {
				//reading in old and new parameters
				String oldCustEmail = session.getAttribute("custEmail").toString();
				String oldCustFirstName = session.getAttribute("custFirstName").toString();
				String oldCustLastName = session.getAttribute("custLastName").toString();
				String oldCustUsername = session.getAttribute("custUsername").toString();
				String custEmail = request.getParameter("custEmail");
				String custFirstName = request.getParameter("custFirstName");
				String custLastName = request.getParameter("custLastName");
				String custAddress = request.getParameter("custAddress");
				String custCity = request.getParameter("custCity");
				String custState = request.getParameter("custState");
				String custZip = request.getParameter("custZip");
				String custTelephone = request.getParameter("custTelephone");
				String custUsername = request.getParameter("custUsername");
				String custPassword = request.getParameter("custPassword");
				
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//make sure account is given username and password
				if (custUsername.equals("")){
					throw new Exception("Username cannot be blank!");
				}
				
				//checking to make sure email, first name, and last name are given
				if (custEmail.equals("") || custFirstName.equals("") || custLastName.equals("")){
					throw new Exception("Email, first name, and last name cannot be blank!");
				}
				
				//updating account username
				String updateCustAccStr = "UPDATE account a "
						+ "SET a.username=?, "
						+ "a.password=? "
						+ "WHERE a.username=?";
						
				PreparedStatement updateCustAccQuery = conn.prepareStatement(updateCustAccStr);
				updateCustAccQuery.setString(1, custUsername);
				updateCustAccQuery.setString(2, custPassword);
				updateCustAccQuery.setString(3, oldCustUsername);
				updateCustAccQuery.executeUpdate();
				updateCustAccQuery.close();
				
				//updating employee info
				String alterCustInfoStr = "UPDATE customer c "
						+ "SET c.email=?, "
						+ "c.name_first=?, "
						+ "c.name_last=?, "
						+ "c.address=?, "
						+ "c.city=?, "
						+ "c.state=?, "
						+ "c.zip=?, "
						+ "c.telephone=? "
						+ "WHERE c.email=? "
						+ "AND c.name_first=? "
						+ "AND c.name_last=?";
				PreparedStatement alterCustInfoQuery = conn.prepareStatement(alterCustInfoStr);
				alterCustInfoQuery.setString(1, custEmail);
				alterCustInfoQuery.setString(2, custFirstName);
				alterCustInfoQuery.setString(3, custLastName);
				
				if (custAddress.equals("")){
					alterCustInfoQuery.setNull(4, java.sql.Types.VARCHAR);
				}else{
					alterCustInfoQuery.setString(4, custAddress);
				}
				
				if (custCity.equals("")){
					alterCustInfoQuery.setNull(5, java.sql.Types.VARCHAR);
				}else{
					alterCustInfoQuery.setString(5, custCity);
				}
				
				if (custState.equals("")){
					alterCustInfoQuery.setNull(6, java.sql.Types.VARCHAR);
				}else{
					alterCustInfoQuery.setString(6, custState);
				}
				
				if (custZip.equals("")){
					alterCustInfoQuery.setNull(7, java.sql.Types.CHAR);
				}else{
					alterCustInfoQuery.setString(7, custZip);
				}
				
				if (custTelephone.equals("")){
					alterCustInfoQuery.setNull(8, java.sql.Types.CHAR);
				}else{
					alterCustInfoQuery.setString(8, custTelephone);
				}
				
				alterCustInfoQuery.setString(9, oldCustEmail);
				alterCustInfoQuery.setString(10, oldCustFirstName);
				alterCustInfoQuery.setString(11, oldCustLastName);
				alterCustInfoQuery.executeUpdate();
				
				//updating session variables
				session.setAttribute("custFirstName", custFirstName);
				session.setAttribute("custLastName", custLastName);
				session.setAttribute("custEmail", custEmail);
				session.setAttribute("custUsername", custUsername);
				
				request.setAttribute("status", "Successful!");
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
				
				//closing connections
				alterCustInfoQuery.close();
				conn.close();
				
			} catch (Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
			}
		
		%>
	</body>
</html>