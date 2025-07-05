<%-- 
    Document   : edit_review
    Created on : Jun 27, 2025, 4:21:55?PM
    Author     : mdmuradhasanmedia
--%>

 <%@ page import="javax.servlet.http.*, java.util.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String movieTitle = (String) request.getAttribute("movieTitle");
    Integer movieId = (Integer) request.getAttribute("movieId");
    Integer score = (Integer) request.getAttribute("score");
    String review = (String) request.getAttribute("review");

    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Review - <%= movieTitle %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Edit Your Review: <%= movieTitle %></h2>

    <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <form action="editreview" method="post">
        <input type="hidden" name="movieId" value="<%= movieId %>">

        <div class="mb-3">
            <label for="score" class="form-label">Rating (1?5)</label>
            <select class="form-select" name="score" id="score" required>
                <% for (int i = 1; i <= 5; i++) { %>
                    <option value="<%= i %>" <%= (i == score) ? "selected" : "" %>><%= i %> Star<%= (i > 1) ? "s" : "" %></option>
                <% } %>
            </select>
        </div>

        <div class="mb-3">
            <label for="review" class="form-label">Review</label>
            <textarea class="form-control" name="review" id="review" rows="6" required><%= review %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Update Review</button>
        <a href="myreviews" class="btn btn-secondary">Back</a>
    </form>
</div>
</body>
</html>
