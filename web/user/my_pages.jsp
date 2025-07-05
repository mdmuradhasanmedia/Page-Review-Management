<%-- 
    Document   : MyPages
    Created on : Jun 27, 2025, 4:19:20?PM
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

    List pages = (List) request.getAttribute("pages");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Pages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2><%= username %>'s Pages</h2>
    <hr/>

    <% if (pages == null || pages.size() == 0) { %>
        <p class="text-muted">You haven't created any pages yet.</p>
    <% } else { %>
        <table class="table table-bordered mt-3">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Title</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (int i = 0; i < pages.size(); i++) {
                        HashMap page = (HashMap) pages.get(i);
                        String title = (String) page.get("title");
                        String createdAt = page.get("created_at").toString();
                        String id = String.valueOf(page.get("id"));
                %>
                <tr>
                    <td><%= i + 1 %></td>
                    <td><%= title %></td>
                    <td><%= createdAt %></td>
                    <td>
                        <a href="viewpage?pageId=<%= id %>" class="btn btn-sm btn-primary">View</a>
                        <a href="editpage?pageId=<%= id %>" class="btn btn-sm btn-warning">Edit</a>
                        <a href="deletepage?pageId=<%= id %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    <% } %>

    <a href="addpage.jsp" class="btn btn-success">+ Add New Page</a>
</div>
</body>
</html>
