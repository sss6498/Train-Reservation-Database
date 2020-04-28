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
		
		
			
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting username from customerAccount.jsp
				String user = session.getAttribute("username").toString();
				
				
				String qid = "";
				String getQid = "SELECT MAX(qid) qid " 
						+ "FROM question";
				
				PreparedStatement getQidQuery = conn.prepareStatement(getQid);
				ResultSet rs0 = getQidQuery.executeQuery();
				rs0.next();
				qid = rs0.getString("qid");
				if (qid.equals(null)){
					qid = "0";
				} else{
					int qidint = Integer.parseInt(qid);
					qidint = qidint+1;
					qid = Integer.toString(qidint);
				}
				getQidQuery.close();
				rs0.close();
				
				String question = request.getParameter("question");				
				String firname = "";
				String user1 = "'"+user+"'";
				String getName_First = "SELECT name_first " 
						+ "FROM customer" 
						+ " WHERE username = "+user1;
				
				PreparedStatement getUsernameQuery = conn.prepareStatement(getName_First);
				
				ResultSet rs = getUsernameQuery.executeQuery();
				
				rs.next();
				firname = rs.getString("name_first");
				//out.print(firname);
				getUsernameQuery.close();
				rs.close();
		
				String lasname = "";
				String getName_Last = "SELECT name_last " 
						+ "FROM customer" 
						+ " WHERE username = "+user1;
				
				PreparedStatement getlnQuery = conn.prepareStatement(getName_Last);
				
				ResultSet rs1 = getlnQuery.executeQuery();
				
				rs1.next();
				lasname = rs1.getString("name_last");
				//out.print(firname);
				getlnQuery.close();
				rs1.close();
					
				String answer = "NULL";
				
				String email = "test2@gmail.com";
				String getemail = "SELECT email " 
						+ "FROM customer" 
						+ " WHERE username = "+user1;
				
				PreparedStatement getemailQuery = conn.prepareStatement(getemail);
				
				ResultSet rs2 = getemailQuery.executeQuery();
				
				rs2.next();
				email = rs2.getString("email");
				//out.print(firname);
				getemailQuery.close();
				rs2.close();

				String ssn = "000000000";
						
				//Don't allow blank questions
				if (question.equals("") || question.equals("?")){
					throw new Exception("Question cannot be blank!");
				}
				
			
				
				String insertQuestionInfoStr = "INSERT INTO question (qid, question, answer, name_first, name_last, email, ssn) "
										+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
				
				PreparedStatement insertQuestionInfoQuery = conn.prepareStatement(insertQuestionInfoStr);
				
				insertQuestionInfoQuery.setString(1, qid);
				insertQuestionInfoQuery.setString(2, question);
				insertQuestionInfoQuery.setString(3, answer);
				insertQuestionInfoQuery.setString(4, firname);
				insertQuestionInfoQuery.setString(5, lasname);
				insertQuestionInfoQuery.setString(6, email);
				insertQuestionInfoQuery.setString(7, ssn);
				
				insertQuestionInfoQuery.executeUpdate();
				
				out.println("Question submitted to the Representative!");
				
				
				insertQuestionInfoQuery.close();
				
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Your question was unable to be submitted.");
				
			}
		%>
	</body>
</html>