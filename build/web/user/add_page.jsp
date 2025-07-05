<%-- 
    Document   : add_page
    Created on : Jun 27, 2025, 4:19:41?PM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="model.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    String message = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Company Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Create Company Page</h2>

    <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/user/AddPageServlet" method="post">
        <div class="mb-3">
            <label for="title" class="form-label">Company Name</label>
            <input type="text" class="form-control" name="title" id="title" required>
        </div>

        <div class="mb-3">
            <label for="contact" class="form-label">Contact Number</label>
            <input type="text" class="form-control" name="contact" id="contact" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" name="email" id="email" required>
        </div>

        <div class="mb-3">
            <label for="location" class="form-label">Location</label>
            <input type="text" class="form-control" name="location" id="location" required>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">Company Description</label>
            <textarea class="form-control" name="content" id="content" rows="6" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Save Company Page</button>
        <a href="${pageContext.request.contextPath}/user/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </form>
</div>
</body>
</html>
