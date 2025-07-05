<%-- 
    Document   : logout
    Created on : Jun 27, 2025, 4:22:42?PM
    Author     : mdmuradhasanmedia
--%>
 <%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logged Out</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta http-equiv="refresh" content="2;url=login.jsp" />
</head>
<body>
<div class="container mt-5 text-center">
    <h2>You have been logged out.</h2>
    <p>Redirecting to login page...</p>
</div>
</body>
</html>
