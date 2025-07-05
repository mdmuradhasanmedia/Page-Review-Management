<%-- 
    Document   : admin_users
    Created on : Jun 20, 2025, 12:54:44 AM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="java.sql.*,util.DBConfig" %>
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
    // --- Get search and page parameters ---
    String search = request.getParameter("search");
    if (search == null) search = "";
    int currentPage = 1;
    int recordsPerPage = 10; // How many users per page
    try {
        String p = request.getParameter("page");
        if (p != null) currentPage = Integer.parseInt(p);
        if (currentPage < 1) currentPage = 1;
    } catch(Exception e) {}

    int totalRecords = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Users</title>
    <style>
        body { font-family: Arial, sans-serif; margin:0; background: #f6f8fa; }
        .container { max-width: 960px; margin: 40px auto; background: #fff; padding: 24px 30px; border-radius: 8px; box-shadow:0 3px 18px #ccc; }
        h2 { color: #225; margin-bottom: 18px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px;}
        th, td { padding: 10px 8px; border-bottom: 1px solid #eee; text-align: left;}
        th { background: #e4ecff; }
        .suspended { color: #c00; font-weight: bold; }
        .ok { color: #080; }
        a.btn { color: #fff; background: #2671e4; padding: 6px 16px; border-radius: 3px; text-decoration: none; margin-right:5px;}
        a.btn:hover { background: #1451a3; }
        .danger { background: #c00; }
        .danger:hover { background: #a00; }
        .green { background: #1dbb41; }
        .green:hover { background: #158c2c; }
        .back { display: inline-block; margin-bottom: 20px; color: #2671e4; text-decoration: none;}
        .pagination { margin:18px 0; }
        .pagination a, .pagination span { display: inline-block; margin: 0 3px; padding: 6px 14px; border-radius: 4px; border: 1px solid #aaa; color:#225; text-decoration: none; }
        .pagination .active { background: #2671e4; color: #fff; border:1px solid #2671e4;}
        .pagination .disabled { color: #aaa; border-color: #eee; }
        .search-box { margin-bottom:18px; }
        .search-input { padding:7px 12px; width: 220px; font-size:1em; border-radius: 3px; border: 1px solid #aaa;}
        .search-btn { padding:7px 16px; font-size:1em; border-radius: 3px; border:none; background:#2671e4; color:#fff; }
    </style>
</head>
<body>
<div class="container">
    <a class="back" href="dashboard.jsp">&larr; Back to Dashboard</a>
    <h2>Manage Users</h2>
    <form class="search-box" method="get" action="users.jsp">
        <input class="search-input" type="text" name="search" value="<%= search %>" placeholder="Search by username, email or name" />
        <button class="search-btn" type="submit">Search</button>
    </form>
    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Full Name</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            Connection con = null;
            PreparedStatement pst = null, countpst = null;
            ResultSet rs = null, countrs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS);

                // --- Count total matching users for pagination ---
                String countSql = "SELECT COUNT(*) FROM users WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ?";
                countpst = con.prepareStatement(countSql);
                String pattern = "%" + search + "%";
                countpst.setString(1, pattern);
                countpst.setString(2, pattern);
                countpst.setString(3, pattern);
                countrs = countpst.executeQuery();
                if (countrs.next()) totalRecords = countrs.getInt(1);

                // --- Main query with LIMIT for pagination ---
                String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?";
                pst = con.prepareStatement(sql);
                pst.setString(1, pattern);
                pst.setString(2, pattern);
                pst.setString(3, pattern);
                pst.setInt(4, recordsPerPage);
                pst.setInt(5, (currentPage-1)*recordsPerPage);

                rs = pst.executeQuery();

                while (rs.next()) {
                    int uid = rs.getInt("id");
                    boolean suspended = rs.getBoolean("is_suspended");
        %>
        <tr>
            <td><%= uid %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td>
                <% if (suspended) { %>
                    <span class="suspended">Suspended</span>
                <% } else { %>
                    <span class="ok">Active</span>
                <% } %>
            </td>
            <td>
                <% if (suspended) { %>
                    <a class="btn green" href="UserStatusServlet?action=activate&id=<%=uid%>&search=<%=search%>&page=<%=currentPage%>">Activate</a>
                <% } else { %>
                    <a class="btn danger" href="UserStatusServlet?action=suspend&id=<%=uid%>&search=<%=search%>&page=<%=currentPage%>">Suspend</a>
                <% } %>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='6' style='color:#c00;'>Error loading users: " + e.getMessage() + "</td></tr>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (pst != null) pst.close(); } catch (Exception e) {}
                try { if (countrs != null) countrs.close(); } catch (Exception e) {}
                try { if (countpst != null) countpst.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>
    </table>
    <%
        int totalPages = (int)Math.ceil(totalRecords / (double)recordsPerPage);
        if (totalPages > 1) {
    %>
    <div class="pagination">
        <% if (currentPage > 1) { %>
            <a href="users.jsp?search=<%=search%>&page=1">&laquo; First</a>
            <a href="users.jsp?search=<%=search%>&page=<%=currentPage-1%>">&lsaquo; Prev</a>
        <% } else { %>
            <span class="disabled">&laquo; First</span>
            <span class="disabled">&lsaquo; Prev</span>
        <% }
           // Show pages around current (max 5 pages)
           int start = Math.max(1, currentPage-2);
           int end = Math.min(totalPages, currentPage+2);
           for (int i=start; i<=end; i++) {
        %>
        <span class="<%= (i==currentPage) ? "active" : "" %>">
            <a href="users.jsp?search=<%=search%>&page=<%=i%>"><%=i%></a>
        </span>
        <% }
        if (currentPage < totalPages) { %>
            <a href="users.jsp?search=<%=search%>&page=<%=currentPage+1%>">Next &rsaquo;</a>
            <a href="users.jsp?search=<%=search%>&page=<%=totalPages%>">Last &raquo;</a>
        <% } else { %>
            <span class="disabled">Next &rsaquo;</span>
            <span class="disabled">Last &raquo;</span>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
