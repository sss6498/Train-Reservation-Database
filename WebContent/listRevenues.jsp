<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>List Revenues -- Group 31 Railway Booking</title>
		<style>
			table {
			  border-collapse: collapse;
			}
			
			td, th {
			  border: 1px solid #dddddd;
			  text-align: left;
			  padding: 8px;
			}
			
			tr:nth-child(even) {
			  background-color: #dddddd;
			}
		</style>
	</head>
	<body>
	
		<%
		try{
			//getting info from admin page
			String revPer = request.getParameter("revPer");
			
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
			
			//making the query
			String revenueStr;
			Statement revenueQuery = conn.createStatement();
			ResultSet revenueRes; 
			
			out.print("<table>");
			out.print("<tr>");
			
			if (revPer.equals("transitLine")){
				
				//adding to header for asthetic
				out.print("	<h1><u> Revenues Per Transit Line </u></h1>");
				
				revenueStr = "SELECT m.line_name, SUM(r.total_fare) total_money "
						+ "FROM made_for m, "
						+ "reservation r "
						+ "WHERE m.reservation_id = r.reservation_id "
						+ "GROUP BY m.line_name";
				revenueRes = revenueQuery.executeQuery(revenueStr);
				
				out.print("<th> Line Name </th>");
				out.print("<th> Total Revenue </th></tr>");
				
				if (revenueRes.next() == false){
					throw new Exception("No revenue data for this criteria!");
				}
				revenueRes.previous();
				
				while(revenueRes.next() != false){
					
					String revenueResLineName = revenueRes.getString("line_name")!=null? revenueRes.getString("line_name"):"";
					String revenueResTotalMoney = revenueRes.getString("total_money")!=null? revenueRes.getString("total_money"):"";
					out.print("<tr>");
					out.print("<td>" + revenueResLineName + "</td>");
					out.print("<td>$" + revenueResTotalMoney + "</td>");
					out.print("</tr>");
				}
					
			}else if (revPer.equals("destinationCity")){
				
				//adding to header for asthetic
				out.print("	<h1><u> Revenues Per Destination City </u></h1>");
				
				revenueStr = "SELECT s.city, SUM(r.total_fare) total_money "
						+ "FROM made_for m, "
						+ "reservation r, "
						+ "follows_a f, "
						+ "station s "
						+ "WHERE r.reservation_id = m.reservation_id "
						+ "AND m.train_id = f.train_id "
						+ "AND m.line_name = f.line_name "
						+ "AND f.destination_id = s.station_id "
						+ "GROUP BY s.city";
				revenueRes = revenueQuery.executeQuery(revenueStr);
				
				out.print("<th> Destination City </th>");
				out.print("<th> Total Revenue </th></tr>");
				
				if (revenueRes.next() == false){
					throw new Exception("No revenue data for this criteria!");
				}
				revenueRes.previous();
				
				while(revenueRes.next() != false){
					
					String revenueResCity = revenueRes.getString("city")!=null? revenueRes.getString("city"):"";
					String revenueResTotalMoney = revenueRes.getString("total_money")!=null? revenueRes.getString("total_money"):"";
					out.print("<tr>");
					out.print("<td>" + revenueResCity + "</td>");
					out.print("<td>$" + revenueResTotalMoney + "</td>");
					out.print("</tr>");
				}
				
			}else{
				
				//adding to header for asthetic
				out.print("	<h1><u> Revenues Per Customer </u></h1>");
				
				revenueStr = "SELECT c.name_first, c.name_last, c.email, SUM(r.total_fare) total_money "
						+ "FROM customer c, "
						+ "reservation r "
						+ "WHERE c.username = r.username "
						+ "GROUP BY c.name_first, c.name_last, c.email";
				revenueRes = revenueQuery.executeQuery(revenueStr);
				
				out.print("<th> First Name </th>");
				out.print("<th> Last Name </th>");
				out.print("<th> Email </th>");
				out.print("<th> Total Revenue </th></tr>");
				
				if (revenueRes.next() == false){
					throw new Exception("No revenue data for this criteria!");
				}
				revenueRes.previous();
				
				while(revenueRes.next() != false){
			
					String revenueResFirst = revenueRes.getString("name_first")!=null? revenueRes.getString("name_first"):"";
					String revenueResLast = revenueRes.getString("name_last")!=null? revenueRes.getString("name_last"):"";
					String revenueResEmail = revenueRes.getString("email")!=null? revenueRes.getString("email"):"";
					String revenueResTotalMoney = revenueRes.getString("total_money")!=null? revenueRes.getString("total_money"):"";
					out.print("<tr>");
					out.print("<td>" + revenueResFirst + "</td>");
					out.print("<td>" + revenueResLast + "</td>");
					out.print("<td>" + revenueResEmail + "</td>");
					out.print("<td>$" + revenueResTotalMoney + "</td>");
					out.print("</tr>");
					
				}
			}
			
			out.print("</table>");
			
			//closing connections
			revenueRes.close();
			revenueQuery.close();
			conn.close();
			
		}catch(Exception e){
			request.setAttribute("status", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
			rd.forward(request, response);
		}
		%>
		
		<br>
		<form method="post" action="adminAccount.jsp">
			<input type="submit" value="Go back to Account!">
		</form>
		
	</body>
</html>