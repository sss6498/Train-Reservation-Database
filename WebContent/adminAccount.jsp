<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Admin -- Group 31 Railway Booking</title>
	</head>
	<body>
		Welcome, Administrator!
		
		<form method="get" action="index.jsp">
			<input type="submit" value="Logout!">
		</form>

		<br>
		
		<b><u> Best Customer!</u></b>
		<!--  Logic needs to be inserted-->
			<ul>
			<% 
				try{
					//The url of our database
					String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
					
					Class.forName("com.mysql.jdbc.Driver");
					
					//Attempting to make a connection to database
					Connection conn = DriverManager.getConnection(url, "group31", "database20");
					
					String bestCustomerStr = 
							"SELECT c.name_first, c.name_last, t1.money "
							+ "FROM customer c, "
							+ "(SELECT *, SUM(r.total_fare) money "
							+ "FROM reservation r "
							+ "GROUP BY r.username) t1 "
							+ "WHERE t1.money = (SELECT MAX(t1.maxMoney) "
							+	"FROM (SELECT SUM(r.total_fare) maxMoney "
							+		"FROM reservation r "
							+		"GROUP BY r.username) t1) "
							+ "AND c.username=t1.username";
					
					Statement bestCustomerQuery = conn.createStatement();
					ResultSet bestCustomerRes = bestCustomerQuery.executeQuery(bestCustomerStr);
					
					if (bestCustomerRes.next() != false){
						String firstName = bestCustomerRes.getString("name_first");
						String lastName = bestCustomerRes.getString("name_last");
						String money = bestCustomerRes.getString("money");
						out.print("<li>" + firstName + " " + lastName + " generating $" + money + " of revenue.</li>");
					}
					
					//closing everything used
					bestCustomerQuery.close();
					bestCustomerRes.close();
					conn.close();
				}catch (Exception e){
					out.print(e.getMessage());
				}
			%>
			</ul>
		
		
		<b><u> Top 5 Most Active Transit Lines in General!</u></b>
		<!--  Logic needs to be inserted-->
			<ul>
			<% 
				try{
					//The url of our database
					String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
					
					Class.forName("com.mysql.jdbc.Driver");
					
					//Attempting to make a connection to database
					Connection conn = DriverManager.getConnection(url, "group31", "database20");
					
					String topFiveTransitStr = "SELECT m.line_name, COUNT(*) num "
							+ "FROM made_for m, "
							+ "reservation r "
							+ "WHERE r.reservation_id=m.reservation_id "
							+ "GROUP BY m.line_name "
							+ "ORDER BY num DESC";
					
					Statement topFiveTransitQuery = conn.createStatement();
					ResultSet topFiveTransitRes = topFiveTransitQuery.executeQuery(topFiveTransitStr);
					
					
					for (int i=0; i<5; i++){
						if (topFiveTransitRes.next() != false){
							String lineName = topFiveTransitRes.getString("line_name");
							String numOfRes = topFiveTransitRes.getString("num");
							out.print("<li>" + lineName + " with " + numOfRes + " reservations.</li>");
						}else{
							break;
						}
					}
					
					//closing everything used
					topFiveTransitQuery.close();
					topFiveTransitRes.close();
					conn.close();
				}catch(Exception e){
					out.print(e.getMessage());
				}
			
			%>
			</ul>
		
	
		<!-- Add, Edit, Delete Fields for Employee -->
		<b><u> Add, Edit, or Delete Information for an Employee</u></b>
		
		<br>

		<form method="post" action="employeeInfo.jsp">
			<label for="employeeAction"> Choose an action: </label>
			<select name="employeeAction" id="employeeAction">
				<option value="Create An Account"> Create An Account </option>
				<option value="Edit An Account"> Edit An Account </option>
				<option value="Delete An Account"> Delete An Account </option>
			</select>
			<br>
			<label for="ssn"> SSN: (without dashes)</label>
			<input name="ssn" maxlength="9" id="ssn" type="text">
			<br>
			<input type="submit" value="Execute Action!">
		</form>
		
		<br>
		
		<!-- Add, Edit, Delete Fields for Customer -->
		<b><u> Add, Edit, or Delete Information for an Customer</u></b>
		<br>
		<form method="post" action="customerInfo.jsp">
			<label for="customerAction"> Choose an action: </label>
			<select name="customerAction" id="customerAction">
				<option value="Create An Account"> Create An Account </option>
				<option value="Edit An Account"> Edit An Account </option>
				<option value="Delete An Account"> Delete An Account </option>
			</select>
			<br>
			<label for="custFirstName"> First Name: </label>
			<input name="custFirstName" maxlength="30" id="custFirstName" type="text">
			<br>
			<label for="custLastName"> Last Name: </label>
			<input name="custLastName" maxlength="30" id="custLastName" type="text">
			<br>
			<label for="custEmail"> Email:  </label>
			<input name="custEmail" maxlength="30" id="custEmail" type="text">
			<br>
			<input type="submit" value="Execute Action!">
		</form>
		
		<br>
		
		<!-- For Monthly Sales Reports -->
		<b><u> View Monthly Sales Reports</u></b>
		<br>
		<form method="post" action="salesReport.jsp">
			<label for="salesMonth"> Month: </label>
			<select name="salesMonth" id="salesMonth">
				<option value="01"> January </option>
				<option value="02"> February </option>
				<option value="03"> March </option>
				<option value="04"> April </option>
				<option value="05"> May </option>
				<option value="06"> June </option>
				<option value="07"> July </option>
				<option value="08"> August </option>
				<option value="09"> September </option>
				<option value="10"> October </option>
				<option value="11"> November </option>
				<option value="12"> December </option>
			</select>
			<br>
			<label for="salesYear"> Year: </label>
			<input name="salesYear" id="salesYear" type="text">
			<br>
			<input type="submit" value="Submit!">
		</form>
		
		<br>
		
		<!-- Finding Reservations -->
		<b><u> Find Reservations: </u></b>
		<br>
		<form method="post" action="findReservations.jsp">
			<label for="trainLineRes"> Train Line Name: </label>
			<input name="trainLineRes" maxlength="30" id="trainLineRes" type="text">
			<br>
			<label for="trainNumberRes"> Train Number: </label>
			<input name="trainNumberRes" id="trainNumberRes" maxlength="4" type="text">
			<br>
			<input type="submit" value="Find Reservations!">
		</form>
		
		<br>
		
		<u> OR USE: </u>
		
		<br>
		<br>
		
		<form method="post" action="findReservations.jsp">
			<label for="resFirst"> Customer First Name: </label>
			<input name="resFirst" maxlength="30" id="resFirst" type="text">
			<br>
			<label for="resLast"> Customer Last Name: </label>
			<input name="resLast" maxlength="30" id="resLast" type="text">
			<br>
			<label for="resEmail"> Email:  </label>
			<input name="resEmail" maxlength="30" id="resEmail" type="text">
			<br>
			<input type="submit" value="Find Reservations!">
		</form>
		
		<br>

		<!-- Finding/Determining Revenue -->
		<b><u> Determine Revenue: </u></b>
		<form method="post" action="listRevenues.jsp">
			<label for="revPer"> Revenue Per: </label>
			<select name="revPer" id="revPer">
				<option value="transitLine"> Transit Line </option>
				<option value="destinationCity"> Destination City </option>
				<option value="customer"> Customer </option>
			</select>
			<br>
			<input type="submit" value="List Revenues!">
		</form>
		
	</body>
</html>