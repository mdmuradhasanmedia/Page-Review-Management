<%-- 
    Document   : company_detail
    Created on : Jun 27, 2025, 4:21:27?PM
    Author     : mdmuradhasanmedia
--%>

 <%@ page import="java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    Map<String, Object> company = (Map<String, Object>) request.getAttribute("company");

    if (company == null) {
%>
    <div class="alert alert-danger mt-5 container">Company not found.</div>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= company.get("name") %> - Company Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2><%= company.get("name") %></h2>
    <p><strong>Industry:</strong> <%= company.get("industry") %></p>
    <p><strong>Location:</strong> <%= company.get("location") %></p>
    <p><strong>Description:</strong></p>
    <p><%= company.get("description") %></p>

    <a href="companies" class="btn btn-secondary mt-3">Back to List</a>
</div>
</body>
</html>
