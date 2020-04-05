<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Employee Info -- Group 31 Railway Booking</title>
	</head>
	<body>
		<% 
			try{
				//account status 0 means create, 1 means edit, 2 means delete
				int accountStatus;
				String empSsn;
				String empFirstName;
				String empLastName;
				String empUsername;
				
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting action and ssn of admin
				String employeeAction = request.getParameter("employeeAction");
				empSsn = request.getParameter("ssn");
				
				//throwing error if ssn is blank
				if (empSsn.equals("")){
					throw new Exception("SSN cannot be blank!");
				}
				
				if (employeeAction.equals("Create An Account")){
					accountStatus = 0;
					out.print("Fill out all the remaining feilds");
				}else if (employeeAction.equals("Edit An Account")){
					accountStatus = 1;
					//c
				}else{
					//can just have query to delete account
					accountStatus = 2;
					
					//getting the username of the employee
					String getUsername = "SELECT e.username " 
							+ "FROM employee e " 
							+ "WHERE e.ssn=?";
					PreparedStatement getUsernameQuery = conn.prepareStatement(getUsername);
					getUsernameQuery.setString(1, empSsn);
					ResultSet rs = getUsernameQuery.executeQuery();
					
					//parsing results for username
					rs.next();
					empUsername = rs.getString("username");
					
					//deleteing employee
  					String empDeleteStr = "DELETE FROM employee "
							+ "WHERE employee.ssn=?";
					PreparedStatement empDeleteQuery = conn.prepareStatement(empDeleteStr);
					empDeleteQuery.setString(1, empSsn);
					empDeleteQuery.executeUpdate();  
					
					//deleteing employee account
   					String accountDeleteStr = "DELETE FROM account "
							+ "WHERE account.username=?";
					PreparedStatement accountDeleteQuery = conn.prepareStatement(accountDeleteStr);
					accountDeleteQuery.setString(1, empUsername);
					accountDeleteQuery.executeUpdate();
					
					//sending result to the adminActionStatus page
					request.setAttribute("status", "Delete Successful!");
					RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
					rd.forward(request, response);
					
					//closing everything
					rs.close();
					empDeleteQuery.close();
					accountDeleteQuery.close();
				}

				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
			}
		%>
	</body>
</html>