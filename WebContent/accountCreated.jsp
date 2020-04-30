<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>    
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Account Creation -- Group 31 Railway Booking</title>
	</head>
	<body>
		<%
			String custFirstName = null;
			String custLastName = null;
			String custEmail = null;
			
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting first name, last name, and emial from index.jsp
				custFirstName = request.getParameter("firstNameCreate");
				custLastName = request.getParameter("lastNameCreate");
				custEmail = request.getParameter("emailCreate");
				
				//Don't allow blank usernames
				if (custFirstName.equals("") || custLastName.equals("") || custEmail.equals("")){
					throw new Exception("First Name, Last Name, or Email cannot be blank!");
				}
				
				//delete any accounts that are "" in preparation for the next step
				String deleteEmptyAccStr = "DELETE FROM account "
						+ "WHERE account.username=?";
				PreparedStatement deleteEmptyAccQuery = conn.prepareStatement(deleteEmptyAccStr);
				deleteEmptyAccQuery.setString(1, "");
				deleteEmptyAccQuery.executeUpdate();
				deleteEmptyAccQuery.close();
				
				//create a blank a blank tmp account for employee
				String createAccStr = "INSERT INTO account(username, password) "
						+ "VALUES (?, ?)";
				PreparedStatement createAccQuery = conn.prepareStatement(createAccStr);
				createAccQuery.setString(1, "");
				createAccQuery.setString(2, "");
				createAccQuery.executeUpdate();
				createAccQuery.close();
				
				//creating account in database
				String insertAccountInfoStr = "INSERT INTO customer (name_first, name_last, email, username) "
										+ "VALUES (?, ?, ?, ?)";
				
				PreparedStatement insertAccountInfoQuery = conn.prepareStatement(insertAccountInfoStr);
				insertAccountInfoQuery.setString(1, custFirstName);
				insertAccountInfoQuery.setString(2, custLastName);
				insertAccountInfoQuery.setString(3, custEmail);
				insertAccountInfoQuery.setString(4, "");
				insertAccountInfoQuery.executeUpdate();
				out.println("Account is almost created, " + custFirstName + "!");
				
				//putting variables in session
				session.setAttribute("custEmail", custEmail);
				session.setAttribute("custFirstName", custFirstName);
				session.setAttribute("custLastName", custLastName);
				
				//closing all objects
				insertAccountInfoQuery.close();

				conn.close();
				
				
			}catch(Exception e){
				request.setAttribute("status", e.getMessage());
				RequestDispatcher rd = request.getRequestDispatcher("/accountCreationStatus.jsp");
				rd.forward(request, response);
			}
		%>
		
		<br>
		<br>
		<form method="post" action="processAccountCreated.jsp">
			<label for="custFirstName"> First Name: </label>
			<input name="custFirstName" maxlength="30" id="custFirstName" type="text" value="<% out.print(custFirstName); %>">
			<br>
			<label for="custLastName"> Last Name: </label>
			<input name="custLastName" maxlength="30" id="custLastName" type="text" value="<% out.print(custLastName); %>">
			<br>
			<label for="custEmail"> Email: </label>
			<input name="custEmail" maxlength="30" id="custEmail" type="text" value="<% out.print(custEmail); %>">
			<br>
			<label for="custAddress"> Address: </label>
			<input name="custAddress" maxlength="30" id="custAddress" type="text">
			<br>
			<label for="custCity"> City: </label>
			<input name="custCity" maxlength="30" id="custCity" type="text">
			<br>
			<label for="custState"> State: </label>
			<input name="custState" maxlength="30" id="custState" type="text">
			<br>
			<label for="custZip"> Zip: </label>
			<input name="custZip" maxlength="5" id="custZip" type="text">
			<br>
			<label for="custTelephone"> Telephone: </label>
			<input name="custTelephone" maxlength="15" id="custTelephone" type="text">
			<br>
			<label for="custUsername"> Account Username: </label>
			<input name="custUsername" maxlength="20" id="custUsername" type="text">
			<br>
			<label for="custPassword"> Account Password: </label>
			<input name="custPassword" maxlength="20" id="custPassword" type="text">
			<br>
			<input type="submit" value="Create Account!">
		</form>
	</body>
</html>