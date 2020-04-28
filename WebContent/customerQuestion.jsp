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
		<%
		
			
			try{
				//The url of our databse
				String url = "jdbc:mysql://mydb.cqqcfvqve8mb.us-east-2.rds.amazonaws.com:3306/cs336RailwayBookingSystem";
				
				Class.forName("com.mysql.jdbc.Driver");
				
				//Attempting to make a connection to database
				Connection conn = DriverManager.getConnection(url, "group31", "database20");
				
				//Getting username and pass from customerAccount.jsp
				String qid = "2";
				String question = request.getParameter("question");
				String firname = request.getParameter("username");
				String lasname = "Customer";
				String answer = "NULL";
				String email = "test2@gmail.com";
				String ssn = "000000000";
						
				//Don't allow blank questions
				if (question.equals("") || question.equals("?")){
					throw new Exception("Question cannot be blank!");
				}
				
				//Looking up the account in the database
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
				
				//closing all objects
				insertQuestionInfoQuery.close();
				conn.close();
				
				
			}catch(Exception e){
				out.print(e.getMessage());
				out.print("<br>");
				out.print("Your question was unable to be submitted.");
				out.print(request.getParameter("first"));
				out.print(request.getParameter("last"));
			}
		%>
	</body>
</html>