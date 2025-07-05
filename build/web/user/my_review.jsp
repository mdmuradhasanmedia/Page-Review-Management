<%-- 
    Document   : my_review
    Created on : Jun 27, 2025, 4:20:27?PM
    Author     : mdmuradhasanmedia
--%>
 <%@ page import="java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> reviews = (List<Map<String, Object>>) request.getAttribute("reviews");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Reviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2><%= username %>'s Reviews</h2>
    <%
        if (reviews == null || reviews.isEmpty()) {
    %>
        <p class="text-muted mt-3">You have not submitted any reviews yet.</p>
    <%
        } else {
    %>
    <table class="table table-bordered mt-3">
        <thead class="table-light">
            <tr>
                <th>Movie Title</th>
                <th>Rating</th>
                <th>Review</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, Object> r : reviews) {
        %>
            <tr>
                <td><%= r.get("title") %></td>
                <td><%= r.get("score") %>/5</td>
                <td><%= r.get("review") %></td>
                <td>
                    <a href="editReview?movieId=<%= r.get("movie_id") %>" class="btn btn-sm btn-warning">Edit</a>
                    <a href="deleteReview?movieId=<%= r.get("movie_id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>
