package user;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class MyPagesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        List<HashMap<String, Object>> pageList = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            String sql = "SELECT id, title, created_at FROM pages WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                HashMap<String, Object> page = new HashMap<>();
                page.put("id", rs.getInt("id"));
                page.put("title", rs.getString("title"));
                page.put("created_at", rs.getTimestamp("created_at"));
                pageList.add(page);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("pages", pageList);
        request.getRequestDispatcher("user/my_pages.jsp").forward(request, response);
    }
}
