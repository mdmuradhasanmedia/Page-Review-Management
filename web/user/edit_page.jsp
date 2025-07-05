<%-- 
    Document   : edit_page
    Created on : Jun 27, 2025, 4:20:02?PM
    Author     : mdmuradhasanmedia
--%>

 <%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String title = (String) request.getAttribute("title");
    String content = (String) request.getAttribute("content");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Page - <%= title %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Edit Page: <%= title %></h2>

    <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <form action="editpage" method="post">
        <input type="hidden" name="originalTitle" value="<%= title %>">

        <div class="mb-3">
            <label for="title" class="form-label">New Title</label>
            <input type="text" class="form-control" name="title" id="title" value="<%= title %>" required>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">Page Content</label>
            <textarea class="form-control" name="content" id="content" rows="8" required><%= content %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Update Page</button>
        <a href="mypages" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
