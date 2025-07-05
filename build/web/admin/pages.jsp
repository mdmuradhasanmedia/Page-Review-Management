<%-- 
    Document   : pages
    Created on : Jun 24, 2025, 3:18:18 PM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    String adminUser = (String) session.getAttribute("admin");
    if (adminUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%
    String dbUrl = util.DBConfig.DB_URL;
    String dbUser = util.DBConfig.DB_USER;
    String dbPass = util.DBConfig.DB_PASS;

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Pages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>All Pages</h2>
    <hr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String sql = "SELECT p.*, u.email, u.is_suspended FROM pages p JOIN users u ON p.user_id = u.id ORDER BY p.id DESC";
        pst = con.prepareStatement(sql);
        rs = pst.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm");

%>
        <table class="table table-bordered table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>User Email</th>
                    <th>Created At</th>
                    <th>Approved</th>
                    <th>Suspended</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
<%
        while (rs.next()) {
            int pageId = rs.getInt("id");
            String title = rs.getString("title");
            String email = rs.getString("email");
            Timestamp createdAt = rs.getTimestamp("created_at");
            boolean isApproved = rs.getBoolean("is_approved");
            boolean isSuspended = rs.getBoolean("is_suspended");
%>
            <tr>
                <td><%= pageId %></td>
                <td><%= title %></td>
                <td><%= email %></td>
                <td><%= sdf.format(createdAt) %></td>
                <td><%= isApproved ? "Yes" : "No" %></td>
                <td><%= isSuspended ? "Yes" : "No" %></td>
                <td>
                    <!-- Approve/Unapprove Page -->
                    <form action="TogglePageApprovalServlet" method="post" class="d-inline">
                        <input type="hidden" name="page_id" value="<%= pageId %>">
                        <button class="btn btn-sm btn-<%= isApproved ? "warning" : "success" %>">
                            <%= isApproved ? "Unapprove" : "Approve" %>
                        </button>
                    </form>

                    <!-- Suspend/Unsuspend User -->
                    <form action="ToggleUserSuspendServlet" method="post" class="d-inline">
                        <input type="hidden" name="user_email" value="<%= email %>">
                        <button class="btn btn-sm btn-<%= isSuspended ? "secondary" : "danger" %>">
                            <%= isSuspended ? "Unsuspend" : "Suspend" %>
                        </button>
                    </form>
                </td>
            </tr>
<%
        }
%>
            </tbody>
        </table>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>
</div>
</body>
</html>
