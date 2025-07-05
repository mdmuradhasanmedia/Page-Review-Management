<%-- 
    Document   : DashBoard
    Created on : Jun 27, 2025, 4:18:34?PM
    Author     : mdmuradhasanmedia
--%>

<%@ page import="model.User, model.Page, dao.PageDAO, java.util.List" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    PageDAO pageDAO = new PageDAO();
    List<Page> pages = pageDAO.getPagesByUserId(user.getUserId());

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Welcome, <%= user.getUsername() %>!</h2>

    <% if (msg != null && msg.equals("page_added")) { %>
        <div class="alert alert-success">Page added successfully!</div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Your Company Pages</h4>
        <a href="add_page.jsp" class="btn btn-primary">+ Add New Page</a>
    </div>

    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th>#</th>
            <th>Company Name</th>
            <th>Contact</th>
            <th>Email</th>
            <th>Location</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            int count = 1;
            if (pages != null && !pages.isEmpty()) {
                for (Page pg : pages) {
        %>
            <tr>
                <td><%= count++ %></td>
                <td><%= pg.getTitle() %></td>
                <td><%= pg.getContact() %></td>
                <td><%= pg.getEmail() %></td>
                <td><%= pg.getLocation() %></td>
                <td>
                    <a href="view_page.jsp?id=<%= pg.getPageId() %>" class="btn btn-sm btn-info">View</a>
                    <a href="edit_page.jsp?id=<%= pg.getPageId() %>" class="btn btn-sm btn-warning">Edit</a>
                    <a href="delete_page.jsp?id=<%= pg.getPageId() %>" class="btn btn-sm btn-danger"
                       onclick="return confirm('Are you sure you want to delete this page?')">Delete</a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="6" class="text-center">No pages found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>

    <form action="${pageContext.request.contextPath}/user/LogoutServlet" method="post" class="mt-4">
        <button type="submit" class="btn btn-danger">Logout</button>
    </form>
</div>
</body>
</html>
