<%-- 
    Document   : admin_logout
    Created on : Jun 20, 2025, 12:49:34 AM
    Author     : mdmuradhasanmedia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.removeAttribute("admin");
    session.invalidate();
    response.sendRedirect("admin_login.jsp");
%>
