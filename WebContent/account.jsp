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
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting username and pass from index.jsp
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				
				//Looking up the account in the database
				String accountLookupStr = "SELECT username, password "
							+ "FROM account "
							+ "WHERE username=?";
				
				PreparedStatement accountLookupQuery = conn.prepareStatement(accountLookupStr);
				accountLookupQuery.setString(1, username);
				
				//Executing the query
				ResultSet result = accountLookupQuery.executeQuery();
				
				//Parsing results
				result.next();
				
				//Checking if passwords match
				if (!result.getString("password").equals(password)){
					throw new Exception("Incorrect password!");
				}
				
				//Checking if it is an employee account
				boolean employeeAccount = false;
				
				String checkEmplAccStr = "SELECT * "
						+ "FROM employee e "
						+ "WHERE e.username=?";
				
				PreparedStatement checkEmplAccQuery = conn.prepareStatement(checkEmplAccStr);
				checkEmplAccQuery.setString(1, username);
				
				ResultSet checkEmplAccRes = checkEmplAccQuery.executeQuery();
				
				if (checkEmplAccRes.next() == true){
					employeeAccount = true;
				}
				
				//redirecting to admin account or customer account
				if (username.equals("admin")){
					RequestDispatcher rd = request.getRequestDispatcher("/adminAccount.jsp");
					rd.forward(request, response);
				}else if (employeeAccount == true){
					RequestDispatcher rd = request.getRequestDispatcher("/employeeAccount.jsp");
					rd.forward(request, response);
				}else {
					RequestDispatcher rd = request.getRequestDispatcher("/customerAccount.jsp");
					rd.forward(request, response);
				}
				
				//closing all objects
				checkEmplAccRes.close();
				checkEmplAccQuery.close();
				result.close();
				accountLookupQuery.close();
				conn.close();
				
			}catch(Exception e){
				out.print(e);
				out.print("<br>");
				out.print("Sorry, your account either does not exist, or your username/password is incorrect.");
			}
		%>
		
	</body>
</html>