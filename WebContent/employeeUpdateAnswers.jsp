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
	<button type="button" name="back" onclick="history.back()">Back</button>
	<br>
	<%
	    
		try {
			String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, "group31", "database20");
		
			
			Statement stmt = conn.createStatement();

			String number = request.getParameter("number");
			String answer = request.getParameter("answer");
			//out.print(number);
			//out.print(answer);
			String username = session.getAttribute("username").toString();
			
			

			String answer1 = "'"+answer+"'";
			String updateAns = "";
			String getans = "UPDATE question " 
					+ "set answer = "+answer1 
					+ " WHERE question.qid = "+number;
			
			PreparedStatement getansQuery = conn.prepareStatement(getans);
			
			getansQuery.executeUpdate();
			getansQuery.close();
			
			String username1 = "'"+username+"'";
			String ssn ="";
			String getssn = "SELECT ssn "
					+"from employee "
					+"where username = "+ username1;
			
			PreparedStatement getssnQuery = conn.prepareStatement(getssn);
			
			ResultSet rs2 = getssnQuery.executeQuery();
			
			rs2.next();
			ssn = rs2.getString("ssn");
			getssnQuery.close();
			rs2.close();
			
			
			String ssn1 = "'"+ssn+"'";

			String updatessn = "";
			String getnewssn = "Update question "
					+"set ssn = "+ssn1
					+" where question.qid = "+number;
			
			PreparedStatement getnewssnQuery = conn.prepareStatement(getnewssn);
			
			getnewssnQuery.executeUpdate();
			getnewssnQuery.close();
	
			out.print("Question Answered!!");
			
			conn.close();
		} catch (Exception e) {
			out.print(e);
			out.print("Question was Unable to be Answered.");
		}
	%>

	</body>
</html>