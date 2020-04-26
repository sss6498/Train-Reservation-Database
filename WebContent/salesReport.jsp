<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Sales Report -- Group 31 Railway Booking</title>
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
			String monthSelected = request.getParameter("salesMonth");
			String yearSelected = request.getParameter("salesYear");
			
			//if no year is entered
			if (yearSelected.equals("")){
				throw new Exception("No year entered!");
			}
			
			out.print("<h1> <u> Sales Report for " + monthSelected + "/" + yearSelected + "</u> </h1>");
			
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
			
			//query database for all reservations made
			String salesReportStr = "SELECT * "
					+ "FROM reservation r "
					+ "WHERE MONTH(r.date)=? "
					+ "AND YEAR(r.date)=?";
			PreparedStatement salesReportQuery = conn.prepareStatement(salesReportStr);
			salesReportQuery.setString(1, monthSelected);
			salesReportQuery.setString(2, yearSelected);
			ResultSet salesReportRes = salesReportQuery.executeQuery();
			
			if (salesReportRes.next() == false){
				throw new Exception("No sales of this criteria found!");
			}
			
			//going back to prev element
			salesReportRes.previous();
			
			//creating table containing all reservations
			out.print("<table>");
			out.print("<tr>");
			out.print("<th> Reservation ID </th>");
			out.print("<th> Date </th>");
			out.print("<th> Username </th>");
			out.print("<th> Class </th>");
			out.print("<th> Seat Number </th>");
			out.print("<th> Booking Fee </th>");
			out.print("<th> Customer Representative </th>");
			out.print("<th> Total Fare </th>");
			out.print("</tr>");
			
			while(salesReportRes.next() != false){
				String salesResRid = salesReportRes.getString("reservation_id")!=null? salesReportRes.getString("reservation_id"):"";
				String salesResDate = salesReportRes.getString("date")!=null? salesReportRes.getString("date"):"";
				String salesResUname = salesReportRes.getString("username")!=null? salesReportRes.getString("username"):"";
				String salesResClass = salesReportRes.getString("class")!=null? salesReportRes.getString("class"):"";
				String salesResSeatNum = salesReportRes.getString("seat_num")!=null? salesReportRes.getString("seat_num"):"";
				String salesResBookingFee = salesReportRes.getString("booking_fee")!=null? salesReportRes.getString("booking_fee"):"";
				String salesResCustRep = salesReportRes.getString("customer_rep")!=null? salesReportRes.getString("customer_rep"):"";
				String salesResTotalFare = salesReportRes.getString("total_fare")!=null? salesReportRes.getString("total_fare"):"";
				
				out.print("<tr>");
				out.print("<td>" + salesResRid + "</td>");
				out.print("<td>" + salesResDate + "</td>");
				out.print("<td>" + salesResUname + "</td>");
				out.print("<td>" + salesResClass + "</td>");
				out.print("<td>" + salesResSeatNum + "</td>");
				out.print("<td>$" + salesResBookingFee + "</td>");
				out.print("<td>" + salesResCustRep + "</td>");
				out.print("<td>$" + salesResTotalFare + "</td>");
				out.print("</tr>");
			}
			
			out.print("</table>");
			
			//calculating total revenue
			String totalRevStr = "SELECT SUM(r.total_fare) totalRev "
					+ "FROM reservation r";
			Statement totalRevQuery = conn.createStatement();
			ResultSet totalRevRes = totalRevQuery.executeQuery(totalRevStr);
			
			totalRevRes.next();
			
			out.print("<br>");
			out.print("<b><u> Total Revenue: $" + totalRevRes.getString("totalRev") + "</u></b>");
			
			//closing open queries, result set, and connection
			totalRevQuery.close();
			totalRevRes.close();
			salesReportQuery.close();
			salesReportRes.close();
			conn.close();
		}catch (Exception e){
			request.setAttribute("status", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
			rd.forward(request, response);
		}
		
		%>
		
		
	</body>
</html>