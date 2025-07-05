package user;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ViewPageServlet extends HttpServlet {
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
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("content", rs.getString("content"));
                request.getRequestDispatcher("user/view_page.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("mypages");
    }
}
