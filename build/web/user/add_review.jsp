<%-- 
    Document   : add_review
    Created on : Jun 27, 2025, 4:20:45?PM
    Author     : mdmuradhasanmedia
--%>
 
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id");
    String movieTitle = (String) request.getAttribute("movieTitle");
    Integer movieId = (Integer) request.getAttribute("movieId");

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Review - <%= movieTitle %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Review: <%= movieTitle %></h2>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>
    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <form action="addreview" method="post">
        <input type="hidden" name="movieId" value="<%= movieId %>">

        <div class="mb-3">
            <label for="score" class="form-label">Rating (1?5)</label>
            <select class="form-select" name="score" id="score" required>
                <option value="">Choose rating</option>
                <% for (int i = 1; i <= 5; i++) { %>
                    <option value="<%= i %>"><%= i %> Star<%= (i > 1) ? "s" : "" %></option>
                <% } %>
            </select>
        </div>

        <div class="mb-3">
            <label for="review" class="form-label">Review</label>
            <textarea class="form-control" name="review" id="review" rows="5" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Submit Review</button>
        <a href="movies" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
