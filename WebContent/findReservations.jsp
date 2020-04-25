<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Find Reservations -- Group 31 Railway Booking</title>
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
	
		<h1><u> Reservations </u></h1>
		<%
		try{
			//getting info from admin page
			String trainLineRes = request.getParameter("trainLineRes");
			String trainNumRes = request.getParameter("trainNumberRes");
			String resFirstName = request.getParameter("resFirst");
			String resLastName = request.getParameter("resLast");
			String resEmail = request.getParameter("resEmail");
			
			//figure out which params to use. 0 means train info, 1 means customer info
			int whichCalled  = trainLineRes == null? 1:0;
			
			//checking if any fields are blank
			if (whichCalled == 1){
				if (resFirstName.equals("") || resLastName.equals("") || resEmail.equals("")){
					throw new Exception("First name, Last Name, or Email cannot be blank!");
				}
			}else{
				if (trainLineRes.equals("") || trainNumRes.equals("")){
					throw new Exception("Train Line Name or Train Number cannot be blank!");
				}
			}
			
			//The url of our database
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			
			//Attempting to make a connection to database
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
			
			//making the query
			String reservationStr;
			PreparedStatement reservationQuery;
			ResultSet reservationRes; 
			
			if (whichCalled == 0){
				reservationStr = "SELECT r.reservation_id, r.total_fare, r.date, r.class, r.seat_num, r.booking_fee, r.customer_rep, r.username "
						+ "FROM made_for m, "
						+ "reservation r "
						+ "WHERE m.train_id=? "
						+ "AND m.line_name=? "
						+ "AND r.reservation_id = m.reservation_id";
				reservationQuery = conn.prepareStatement(reservationStr);
				reservationQuery.setInt(1, Integer.parseInt(trainNumRes));
				reservationQuery.setString(2, trainLineRes);
				reservationRes = reservationQuery.executeQuery();
			}else{
				reservationStr = "SELECT r.reservation_id, r.total_fare, r.date, r.class, r.seat_num, r.booking_fee, r.customer_rep, r.username "
						+ "FROM customer c, "
						+ "reservation r "
						+ "WHERE c.username=r.username "
						+ "AND c.name_first=? "
						+ "AND c.name_last=? "
						+ "AND c.email=?";
				reservationQuery = conn.prepareStatement(reservationStr);
				reservationQuery.setString(1, resFirstName);
				reservationQuery.setString(2, resLastName);
				reservationQuery.setString(3, resEmail);
				reservationRes = reservationQuery.executeQuery();
			}
			
			//parsing result set
			if (reservationRes.next() == false){
				throw new Exception("No results of this criteria!");
			}
			
			//go back to previous element
			reservationRes.previous();
			
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
			
			while(reservationRes.next() != false){
				String reservationResRid = reservationRes.getString("reservation_id")!=null? reservationRes.getString("reservation_id"):"";
				String reservationResDate = reservationRes.getString("date")!=null? reservationRes.getString("date"):"";
				String reservationResUname = reservationRes.getString("username")!=null? reservationRes.getString("username"):"";
				String reservationResClass = reservationRes.getString("class")!=null? reservationRes.getString("class"):"";
				String reservationResSeatNum = reservationRes.getString("seat_num")!=null? reservationRes.getString("seat_num"):"";
				String reservationResBookingFee = reservationRes.getString("booking_fee")!=null? reservationRes.getString("booking_fee"):"";
				String reservationResCustRep = reservationRes.getString("customer_rep")!=null? reservationRes.getString("customer_rep"):"";
				String reservationResTotalFare = reservationRes.getString("total_fare")!=null? reservationRes.getString("total_fare"):"";
				
				out.print("<tr>");
				out.print("<td>" + reservationResRid + "</td>");
				out.print("<td>" + reservationResDate + "</td>");
				out.print("<td>" + reservationResUname + "</td>");
				out.print("<td>" + reservationResClass + "</td>");
				out.print("<td>" + reservationResSeatNum + "</td>");
				out.print("<td>$" + reservationResBookingFee + "</td>");
				out.print("<td>" + reservationResCustRep + "</td>");
				out.print("<td>$" + reservationResTotalFare + "</td>");
				out.print("</tr>");
			}
			
			out.print("</table>");
			
			//closing open queries, result set, and connection
			reservationQuery.close();
			reservationRes.close();
			conn.close();
		}catch(Exception e){
			request.setAttribute("status", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("/adminActionStatus.jsp");
			rd.forward(request, response);
		}
		
		%>
		
	</body>
</html>