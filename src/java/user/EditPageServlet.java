package user;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditPageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int pageId = Integer.parseInt(request.getParameter("pageId"));

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            String sql = "SELECT title, content FROM pages WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, pageId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("pageId", pageId);
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("content", rs.getString("content"));
                request.getRequestDispatcher("user/edit_page.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("mypages");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int pageId = Integer.parseInt(request.getParameter("pageId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            String sql = "UPDATE pages SET title = ?, content = ?, created_at = NOW() WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, pageId);
            stmt.setInt(4, userId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("mypages");
    }
}
