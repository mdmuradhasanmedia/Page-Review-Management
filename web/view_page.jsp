<%-- 
    Document   : view_page
    Created on : Jun 27, 2025, 6:25:17 PM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dbUrl = util.DBConfig.DB_URL;
    String dbUser = util.DBConfig.DB_USER;
    String dbPass = util.DBConfig.DB_PASS;

    String id = request.getParameter("id");
    if (id == null || !id.matches("\\d+")) {
        out.println("<h3>Invalid Page ID</h3>");
        return;
    }

    int pageId = Integer.parseInt(id);
    int currentPage = request.getParameter("pg") != null ? Integer.parseInt(request.getParameter("pg")) : 1;
    int reviewsPerPage = 5;
    int offset = (currentPage - 1) * reviewsPerPage;

    Connection con = null;
    PreparedStatement pstPage = null, pstReviews = null, pstCount = null, pstAvg = null;
    ResultSet rsPage = null, rsReviews = null, rsCount = null, rsAvg = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Page View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Fetch page info
        String sql = "SELECT p.*, u.is_suspended FROM pages p JOIN users u ON p.user_id = u.id WHERE p.id=?";
        pstPage = con.prepareStatement(sql);
        pstPage.setInt(1, pageId);
        rsPage = pstPage.executeQuery();

        if (rsPage.next()) {
            if (!rsPage.getBoolean("is_approved")) {
%>
    <h3>This page is not approved yet.</h3>
<% return; }

            if (rsPage.getBoolean("is_suspended")) {
%>
    <h3>This user is suspended. Page is not available.</h3>
<% return; }

            String title = rsPage.getString("title");
            String contact = rsPage.getString("contact");
            String email = rsPage.getString("email");
            String location = rsPage.getString("location");
            String content = rsPage.getString("content");
            Timestamp createdAt = rsPage.getTimestamp("created_at");
            String createdFormatted = new SimpleDateFormat("dd MMM yyyy HH:mm").format(createdAt);

            // Fetch average rating
            pstAvg = con.prepareStatement("SELECT AVG(stars) as avg_rating FROM reviews WHERE page_id=? AND is_approved=true");
            pstAvg.setInt(1, pageId);
            rsAvg = pstAvg.executeQuery();
            double avgRating = 0;
            if (rsAvg.next()) avgRating = rsAvg.getDouble("avg_rating");
%>
    <h2><%= title %></h2>
    <p><strong>Contact:</strong> <%= contact %></p>
    <p><strong>Email:</strong> <%= email %></p>
    <p><strong>Location:</strong> <%= location %></p>
    <p><strong>Created:</strong> <%= createdFormatted %></p>
    <p><strong>Average Rating:</strong> <%= String.format("%.1f", avgRating) %> / 5</p>
    <div class="card p-3 my-3"><%= content %></div>

    <hr>
    <h4>Submit Your Review</h4>
    <form id="reviewForm">
        <input type="hidden" name="id" value="<%= pageId %>">
        <div class="mb-2">
            <label>Name</label>
            <input type="text" name="name" required class="form-control">
        </div>
        <div class="mb-2">
            <label>Email</label>
            <input type="email" name="email" required class="form-control">
        </div>
        <div class="mb-2">
            <label>Stars</label>
            <select name="stars" class="form-control" required>
                <% for (int i = 1; i <= 5; i++) { %>
                    <option value="<%= i %>"><%= i %></option>
                <% } %>
            </select>
        </div>
        <div class="mb-2">
            <label>Comment</label>
            <textarea name="comment" rows="3" class="form-control" required></textarea>
        </div>
        <button class="btn btn-primary mt-2">Submit Review</button>
    </form>
    <div id="reviewMsg" class="mt-3"></div>

    <hr>
    <h4>Approved Reviews</h4>
<%
            // Count total reviews
            pstCount = con.prepareStatement("SELECT COUNT(*) FROM reviews WHERE page_id=? AND is_approved=true");
            pstCount.setInt(1, pageId);
            rsCount = pstCount.executeQuery();
            int totalReviews = 0;
            if (rsCount.next()) totalReviews = rsCount.getInt(1);
            int totalPages = (int) Math.ceil(totalReviews / (double) reviewsPerPage);

            // Paginated reviews
            pstReviews = con.prepareStatement("SELECT * FROM reviews WHERE page_id=? AND is_approved=true ORDER BY created_at DESC LIMIT ?, ?");
            pstReviews.setInt(1, pageId);
            pstReviews.setInt(2, offset);
            pstReviews.setInt(3, reviewsPerPage);
            rsReviews = pstReviews.executeQuery();

            boolean found = false;
            while (rsReviews.next()) {
                found = true;
%>
        <div class="card p-2 mb-2">
            <p><strong><%= rsReviews.getString("name") %></strong> 
                (<%= rsReviews.getString("email") %>) 
                - <%= rsReviews.getInt("stars") %> Stars
            </p>
            <p><%= rsReviews.getString("comment") %></p>
            <small class="text-muted"><%= rsReviews.getTimestamp("created_at") %></small>
        </div>
<%          }
            if (!found) { %>
        <p>No approved reviews yet.</p>
<%          }

            if (totalPages > 1) { %>
        <nav>
            <ul class="pagination">
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="view_page.jsp?id=<%= pageId %>&pg=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
            </ul>
        </nav>
<%          }
        } else {
%>
    <h3>Page not found.</h3>
<%
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Something went wrong. Please try again later.</div>");
        e.printStackTrace();
    } finally {
        if (rsPage != null) rsPage.close();
        if (rsReviews != null) rsReviews.close();
        if (rsAvg != null) rsAvg.close();
        if (rsCount != null) rsCount.close();
        if (pstPage != null) pstPage.close();
        if (pstReviews != null) pstReviews.close();
        if (pstCount != null) pstCount.close();
        if (pstAvg != null) pstAvg.close();
        if (con != null) con.close();
    }
%>
</div>

<script>
document.getElementById("reviewForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const form = e.target;
    const formData = new FormData(form);

    fetch("submit_review.jsp", {
        method: "POST",
        body: new URLSearchParams(formData)
    })
    .then(res => res.text())
    .then(data => {
        document.getElementById("reviewMsg").innerHTML = data;
        form.reset();
    })
    .catch(err => {
        document.getElementById("reviewMsg").innerHTML = "<div class='alert alert-danger'>Error submitting review.</div>";
    });
});
</script>
</body>
</html>
