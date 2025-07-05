package user;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        HashMap<String, Object> user = new HashMap<>();

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            String sql = "SELECT username, email, role, created_at FROM users WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("role", rs.getString("role"));
                user.put("created_at", rs.getTimestamp("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }
}
