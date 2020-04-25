<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Customer Info -- Group 31 Railway Booking</title>
	</head>
	<body>
		<% 
			String custEmail = null;
			String custFirstName = null;
			String custLastName = null;
			String custCity = null;
			String custState = null;
			String custTelephone = null;
			String custZip = null;
			String custAddress = null;
			String custUsername = null;
			String custPassword = null;
			
			try{
				//The url of our database
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting action and ssn of admin
				String employeeAction = request.getParameter("customerAction");
				custFirstName = request.getParameter("custFirstName");
				custLastName = request.getParameter("custLastName");
				custEmail = request.getParameter("custEmail");
				
				//throwing error if first name, last name, or email is blank
				if (custFirstName.equals("") || custLastName.equals("") || custEmail.equals("")){
					throw new Exception("Customer first name, last name, and email address cannot be blank!");
				}
				
				if (employeeAction.equals("Create An Account")){
					
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
					
					//creating new customer account
					String createCustAccountStr = "INSERT INTO customer(email, name_first, name_last, username) " 
							+ "VALUES (?, ?, ?, ?)";
					PreparedStatement createCustAccountAct = conn.prepareStatement(createCustAccountStr);
					createCustAccountAct.setString(1, custEmail);
					createCustAccountAct.setString(2, custFirstName);
					createCustAccountAct.setString(3, custLastName);
					createCustAccountAct.setString(4, "");
					createCustAccountAct.executeUpdate();
					createCustAccountAct.close();
					
					out.print("Customer Successfully Created! <br><br>");
					out.print("Fill out the relevant fields below and submit to finish creating account!");
					
				}else if (employeeAction.equals("Edit An Account")){
					
					out.print("Edit the relevant fields below and submit!");
					
				}else{
					//can just have query to delete account
					
					//getting the username of the employee
					String getUsername = "SELECT c.username " 
							+ "FROM customer c " 
							+ "WHERE c.email=? AND c.name_first=? AND c.name_last=?";
					PreparedStatement getUsernameQuery = conn.prepareStatement(getUsername);
					getUsernameQuery.setString(1, custEmail);
					getUsernameQuery.setString(2, custFirstName);
					getUsernameQuery.setString(3, custLastName);
					ResultSet rs = getUsernameQuery.executeQuery();
					
					//parsing results for username
					rs.next();
					custUsername = rs.getString("username");
					
					//deleteing employee account which deleted employee on cascade
   					String accountDeleteStr = "DELETE FROM account "
							+ "WHERE account.username=?";
					PreparedStatement accountDeleteQuery = conn.prepareStatement(accountDeleteStr);
					accountDeleteQuery.setString(1, custUsername);
					accountDeleteQuery.executeUpdate();
					
					//sending result to the adminActionStatus page
					request.setAttribute("status", "Delete Successful!");
					RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
					rd.forward(request, response);
					
					//closing everything
					rs.close();
					accountDeleteQuery.close();
					return;
				}
				
				//populating employee fields
				String findCustomerStr = "SELECT * "
						+ "FROM customer c "
						+ "WHERE c.email=? AND c.name_first=? AND c.name_last=?";
				PreparedStatement findCustomerQuery = conn.prepareStatement(findCustomerStr);
				findCustomerQuery.setString(1, custEmail);
				findCustomerQuery.setString(2, custFirstName);
				findCustomerQuery.setString(3, custLastName);
				ResultSet findCustomerRes = findCustomerQuery.executeQuery();

				if (findCustomerRes.next() == false){
					throw new Exception("Customer not found!");
				}else{
					custEmail = findCustomerRes.getString("email");
					custFirstName = findCustomerRes.getString("name_first");
					custLastName = findCustomerRes.getString("name_last");
					custCity = findCustomerRes.getString("city");
					custState = findCustomerRes.getString("state");
					custTelephone = findCustomerRes.getString("telephone");
					custZip = findCustomerRes.getString("zip");
					custAddress = findCustomerRes.getString("address");
					custUsername = findCustomerRes.getString("username");
				}
				
				findCustomerQuery.close();
				findCustomerRes.close();
				
				//getting employee password for account
				String findCustAccStr = "SELECT * "
						+ "FROM account a "
						+ "WHERE a.username=?";
				PreparedStatement findCustAccQuery = conn.prepareStatement(findCustAccStr);
				findCustAccQuery.setString(1, custUsername);
				
				ResultSet findCustAccRes = findCustAccQuery.executeQuery();
				findCustAccRes.next();
				custPassword = findCustAccRes.getString("password");
				findCustAccQuery.close();
				findCustAccRes.close();
				
				//putting variables in session
				session.setAttribute("custEmail", custEmail);
				session.setAttribute("custFirstName", custFirstName);
				session.setAttribute("custLastName", custLastName);
				session.setAttribute("custAddress", custAddress);
				session.setAttribute("custCity", custCity);
				session.setAttribute("custState", custState);
				session.setAttribute("custZip", custZip);
				session.setAttribute("custTelephone", custTelephone);
				session.setAttribute("custUsername", custUsername);
				session.setAttribute("custPassword", custPassword);
				
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
		
		<form method="post" action="processCustomerUpdate.jsp">
			<label for="custEmail"> Customer Email: </label>
			<input name="custEmail" id="custEmail" type="text" value="<% 
				String tmp = custEmail != null? custEmail:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custFirstName"> Customer First Name: </label>
			<input name="custFirstName" id="custFirstName" type="text" value="<%
				tmp = custFirstName != null? custFirstName:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custLastName"> Customer Last Name: </label>
			<input name="custLastName" id="custLastName" type="text" value="<%
				tmp = custLastName != null? custLastName:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custAddress"> Customer Address: </label>
			<input name="custAddress" id="custAddress" type="text" value="<%
				tmp = custAddress != null? custAddress:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custCity"> Customer City: </label>
			<input name="custCity" id="custCity" type="text" value="<%
				tmp = custCity != null? custCity:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custState"> Customer State: </label>
			<input name="custState" id="custState" type="text" value="<%
				tmp = custState != null? custState:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custZip"> Customer Zip: </label>
			<input name="custZip" id="custZip" type="text" value="<%
				tmp = custZip != null? custZip:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custTelephone"> Customer Telephone: </label>
			<input name="custTelephone" id="custTelephone" type="text" value="<%
				tmp = custTelephone != null? custTelephone:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custUsername"> Customer Account Username: </label>
			<input name="custUsername" id="custUsername" type="text" value="<%
				tmp = custUsername != null? custUsername:"";
				out.print(tmp);
			%>">
			<br>
			<label for="custPassword"> Customer Account Password: </label>
			<input name="custPassword" id="custPassword" type="text" value="<%
				tmp = custPassword != null? custPassword:"";
				out.print(tmp);
			%>">
			<br>
			<input type="submit" value="Update!">
		</form>
	</body>
</html>