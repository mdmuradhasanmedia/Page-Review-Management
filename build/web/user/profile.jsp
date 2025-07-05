<%-- 
    Document   : profile
    Created on : Jun 27, 2025, 4:22:28?PM
    Author     : mdmuradhasanmedia
--%>
 <%@ page import="java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Map<String, Object> user = (Map<String, Object>) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Welcome, <%= username %>!</h2>
    <hr/>

    <% if (user != null) { %>
        <p><strong>Email:</strong> <%= user.get("email") %></p>
        <p><strong>Role:</strong> <%= user.get("role") %></p>
        <p><strong>Joined on:</strong> <%= user.get("created_at") %></p>
    <% } else { %>
        <div class="alert alert-danger">User details could not be loaded.</div>
    <% } %>

    <a href="editprofile.jsp" class="btn btn-warning">Edit Profile</a>
    <a href="logout" class="btn btn-danger">Logout</a>
</div>
</body>
</html>
