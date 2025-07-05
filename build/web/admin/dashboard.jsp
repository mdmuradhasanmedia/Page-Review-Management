<%-- 
    Document   : admin_dashboard
    Created on : Jun 20, 2025, 12:47:17 AM
    Author     : mdmuradhasanmedia
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    String adminUser = (String) session.getAttribute("admin");
    if (adminUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Page Review Management</title>
      <style>
        body { font-family: Arial, sans-serif; background: #f3f8fd; }
        .dashbox { max-width: 680px; margin: 44px auto; background: #fff; border-radius: 12px; box-shadow:0 6px 26px #b1c8ee; padding:30px 40px; }
        h1 { color: #2950a8; }
        .user { float: right; font-size: 1em; color: #444; }
        ul.menu { margin-top:30px; padding:0; list-style:none; }
        ul.menu li { margin-bottom:15px; }
        a.btn {
            display: block;
            padding:12px 18px;
            background: #2671e4;
            color:white;
            border-radius:6px;
            text-decoration:none;
            font-size: 1.1em;
            font-weight: 500;
            transition: background 0.18s;
            box-shadow:0 1px 7px #b5cfff21;
        }
        a.btn:hover { background: #1a549d;}
        .logout { float: right; color:#d34; margin-left:15px; }
    </style>
</head>
<body>
    <div class="dashbox">
        <div>
            <span class="user">Logged in as: <b><%= adminUser %></b></span>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
        <h1>Admin Dashboard</h1>
        <hr>
        <ul class="menu">
            <li><a href="users.jsp" class="btn">Manage Users</a></li>
            <li><a href="pages.jsp" class="btn">Manage Pages</a></li>
            <li><a href="reviews.jsp" class="btn">Manage Reviews</a></li>
            <li><a href="index.jsp" class="btn">Back to Home</a></li>
        </ul>
        <div style="margin-top:38px; color:#888;">You can suspend users/pages, review feedback, and more from here.</div>
    </div>
</body>
</html>

