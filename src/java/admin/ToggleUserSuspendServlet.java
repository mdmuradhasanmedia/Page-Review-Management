package admin;

import util.DBConfig;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ToggleUserSuspendServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("user_email");
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("pages.jsp?error=Invalid+Email");
            return;
        }

        try (Connection con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS)) {
            PreparedStatement select = con.prepareStatement("SELECT is_suspended FROM users WHERE email = ?");
            select.setString(1, email);
            ResultSet rs = select.executeQuery();
            if (rs.next()) {
                boolean currentStatus = rs.getBoolean("is_suspended");
                PreparedStatement update = con.prepareStatement("UPDATE users SET is_suspended = ? WHERE email = ?");
                update.setBoolean(1, !currentStatus);
                update.setString(2, email);
                update.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("pages.jsp");
    }
}
