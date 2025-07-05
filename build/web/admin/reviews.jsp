<%-- 
    Document   : reviews
    Created on : Jun 27, 2025, 7:12:55 PM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBConfig" %>
<%
    // Check admin session (optional if you have session login)
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String dbUrl = DBConfig.DB_URL;
    String dbUser = DBConfig.DB_USER;
    String dbPass = DBConfig.DB_PASS;

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String action = request.getParameter("action");
    String reviewId = request.getParameter("id");

    if (action != null && reviewId != null && reviewId.matches("\\d+")) {
        try {
            con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            if ("approve".equals(action)) {
                pst = con.prepareStatement("UPDATE reviews SET is_approved = 1 WHERE id = ?");
            } else if ("delete".equals(action)) {
                pst = con.prepareStatement("DELETE FROM reviews WHERE id = ?");
            }
            if (pst != null) {
                pst.setInt(1, Integer.parseInt(reviewId));
                pst.executeUpdate();
                pst.close();
            }
            con.close();
            response.sendRedirect("reviews.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Reviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2>All Submitted Reviews</h2>
    <table class="table table-bordered mt-3">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Page Title</th>
            <th>Stars</th>
            <th>Comment</th>
            <th>Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                String sql = "SELECT r.*, p.title AS page_title FROM reviews r " +
                             "JOIN pages p ON r.page_id = p.id ORDER BY r.created_at DESC";
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    int rid = rs.getInt("id");
                    String pageTitle = rs.getString("page_title");
                    int stars = rs.getInt("stars");
                    String comment = rs.getString("comment");
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    boolean is_approved = rs.getBoolean("is_approved");
        %>
        <tr>
            <td><%= rid %></td>
            <td><%= pageTitle %></td>
            <td><%= stars %> ★</td>
            <td><%= comment %></td>
            <td><%= createdAt %></td>
            <td>
                <% if (is_approved) { %>
                    <span class="badge bg-success">Approved</span>
                <% } else { %>
                    <span class="badge bg-warning text-dark">Pending</span>
                <% } %>
            </td>
            <td>
    <% if (!is_approved) { %>
        <button class="btn btn-sm btn-success" onclick="updateReviewStatus(<%= rid %>, true)">Approve</button>
    <% } else { %>
        <button class="btn btn-sm btn-warning" onclick="updateReviewStatus(<%= rid %>, false)">Unapprove</button>
    <% } %>
    <button class="btn btn-sm btn-danger" onclick="deleteReview(<%= rid %>)">Delete</button>
</td>

        </tr>
        <%
                }
                rs.close();
                pst.close();
                con.close();
            } catch (Exception e) {
        %>
        <tr>
            <td colspan="7" class="text-danger">Error loading reviews: <%= e.getMessage() %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>
        
      <script>
function toggleApproval(reviewId, action) {
    fetch('ReviewActionServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + reviewId + '&action=' + action
    })
    .then(res => res.text())
    .then(data => {
        if (data.trim() === 'success') {
            location.reload(); // Or update the DOM without reloading
        } else {
            alert("Failed to update review status.");
        }
    });
}
</script>


</body>
</html>

