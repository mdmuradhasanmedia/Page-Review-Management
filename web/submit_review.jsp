<%-- 
    Document   : submit_review
    Created on : Jun 27, 2025, 7:00:48 PM
    Author     : mdmuradhasanmedia
--%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConfig" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String starsStr = request.getParameter("stars");
    String comment = request.getParameter("comment");

    if (id == null || !id.matches("\\d+") || name == null || email == null || starsStr == null || comment == null) {
        out.print("<div class='alert alert-danger'>Invalid data submitted.</div>");
        return;
    }

    try (Connection con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS)) {
        PreparedStatement checkPage = con.prepareStatement("SELECT id FROM pages WHERE id = ? AND is_approved = 1");
        checkPage.setInt(1, Integer.parseInt(id));
        ResultSet rs = checkPage.executeQuery();
        if (!rs.next()) {
            out.print("<div class='alert alert-warning'>Page is not approved or does not exist.</div>");
            return;
        }

        int stars = Integer.parseInt(starsStr);
        if (stars < 1 || stars > 5) {
            out.print("<div class='alert alert-danger'>Stars must be 1–5.</div>");
            return;
        }

        PreparedStatement pst = con.prepareStatement("INSERT INTO reviews (page_id, name, email, stars, comment, created_at, is_approved) VALUES (?, ?, ?, ?, ?, NOW(), 0)");
        pst.setInt(1, Integer.parseInt(id));
        pst.setString(2, name);
        pst.setString(3, email);
        pst.setInt(4, stars);
        pst.setString(5, comment);
        int inserted = pst.executeUpdate();
        pst.close();

        if (inserted > 0) {
            out.print("<div class='alert alert-success'>Review submitted and pending approval.</div>");
        } else {
            out.print("<div class='alert alert-danger'>Failed to submit review.</div>");
        }
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>
