<%-- 
    Document   : index
    Created on : Jun 20, 2025, 12:07:16 AM
    Author     : mdmuradhasanmedia
--%>
<%@ page import="java.sql.Connection,java.sql.DriverManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Database connection variables
    String dbUrl = "jdbc:mysql://localhost:3306/?serverTimezone=UTC";
    String dbUser = "root"; 
    String dbPass = "Root@1234"; 

    String dbError = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); 
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        conn.close();
    } catch (Exception e) {
        dbError = e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>PageReviewManagement</title>
    <style>
        body { font-family: Arial, sans-serif; margin:40px; }
        .error { color: #b71c1c; background: #ffeaea; border: 1px solid #b71c1c; padding: 14px; border-radius: 6px; margin-bottom: 20px; }
        .welcome { font-size: 1.2em; margin-bottom: 25px; }
        .button { background: #4285F4; color: white; padding: 10px 22px; border: none; border-radius: 5px; font-size: 1em; text-decoration: none; }
        .button:hover { background: #1669b2; }
    </style>
</head>
<body>
    <h1>Welcome to Page Review Management</h1>
    <%
        if (dbError != null) {
    %>
        <div class="error">
            <strong>Database Connection Error:</strong><br>
            <%= dbError %>
        </div>
    <%
        } else {
    %>
        <div class="welcome">
            <p>This platform lets you register, login, manage company pages, and review others.<br>
            Please <b>login</b> to continue.</p>
        </div>
        <a class="button" href="user/login.jsp">Login</a>
        <a class="button" href="user/register.jsp" style="background:#34A853;">Register</a>
    <%
        }
    %>
</body>
</html>
