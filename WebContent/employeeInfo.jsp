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
			String empSsn = null;
			String empFirstName = null;
			String empLastName = null;
			String empUsername = null;
			String empPassword = null;
			
			try{
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
					
					//throw an error if ssn is not 9 digits
					if (empSsn.length() != 9){
						throw new Exception("SSN needs to be 9 digits long!");
					}
					
					//creating new employee account
					String createEmpAccountStr = "INSERT INTO employee(ssn)" 
							+ "VALUES (?)";
					PreparedStatement createEmpAccountAct = conn.prepareStatement(createEmpAccountStr);
					createEmpAccountAct.setString(1, empSsn);
					createEmpAccountAct.executeUpdate();
					createEmpAccountAct.close();
					
					out.print("Employee Successfully Created! <br><br>");
					out.print("Fill out the relevant fields below and submit to finish creating account!");
					
				}else if (employeeAction.equals("Edit An Account")){
					
					out.print("Edit the relevant fields below and submit!");
					
				}else{
					//can just have query to delete account
					
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
				
				//populating employee fields
				String findEmployeeStr = "SELECT * "
						+ "FROM employee e "
						+ "WHERE e.ssn=?";
				PreparedStatement findEmployeeQuery = conn.prepareStatement(findEmployeeStr);
				findEmployeeQuery.setString(1, empSsn);
				ResultSet findEmployeeRes = findEmployeeQuery.executeQuery();

				if (findEmployeeRes.next() == false){
					throw new Exception("Employee not found!");
				}else{
					empSsn = findEmployeeRes.getString("ssn");
					empFirstName = findEmployeeRes.getString("name_first");
					empLastName = findEmployeeRes.getString("name_last");
					empUsername = findEmployeeRes.getString("username");
				}
				
				findEmployeeQuery.close();
				findEmployeeRes.close();
				
				//getting employee password for account
				if (empUsername != null){
					String findEmployeeAccStr = "SELECT * "
							+ "FROM account a "
							+ "WHERE a.username=?";
					PreparedStatement findEmployeeAccQuery = conn.prepareStatement(findEmployeeAccStr);
					findEmployeeAccQuery.setString(1, empUsername);
					ResultSet findEmployeeAccRes = findEmployeeAccQuery.executeQuery();
					findEmployeeAccRes.next();
					empPassword = findEmployeeAccRes.getString("password");
					findEmployeeAccQuery.close();
					findEmployeeAccRes.close();
				}
				
				//putting variables in session
				session.setAttribute("empSsn", empSsn);
				session.setAttribute("empFirstName", empFirstName);
				session.setAttribute("empLastName", empLastName);
				session.setAttribute("empUsername", empUsername);
				session.setAttribute("empPassword", empPassword);
				
				//closing the connection
				conn.close();
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
				rd.forward(request, response);
			}
		%>
		
		<br>
		<br>
		
		<form method="post" action="processEmployeeUpdate.jsp">
			<label for="empSSN"> SSN: (without dashes)</label>
			<input name="empSSN" maxlength="9" id="empSSN" type="text" value=<% 
				String tmp = empSsn != null? empSsn:"";
				out.print(tmp);
			%>>
			<br>
			<label for="empFirstName"> Employee First Name: </label>
			<input name="empFirstName" id="empFirstName" type="text" value=<%
				tmp = empFirstName != null? empFirstName:"";
				out.print(tmp);
			%>>
			<br>
			<label for="empLastName"> Employee Last Name: </label>
			<input name="empLastName" id="empLastName" type="text" value=<%
				tmp = empLastName != null? empLastName:"";
				out.print(tmp);
			%>>
			<br>
			<label for="empAccountUsername"> Employee Account Username: </label>
			<input name="empAccountUsername" id="empAccountUsername" type="text" value=<%
				tmp = empUsername != null? empUsername:"";
				out.print(tmp);
			%>>
			<br>
			<label for="empAccountPassword"> Employee Account Password: </label>
			<input name="empAccountPassword" id="empAccountPassword" type="text" value=<%
				tmp = empPassword != null? empPassword:"";
				out.print(tmp);
			%>>
			<br>
			<input type="submit" value="Update!">
		</form>
		
	</body>
</html>