package admin;

import util.DBConfig;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class TogglePageApprovalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageIdStr = request.getParameter("page_id");
        if (pageIdStr == null || !pageIdStr.matches("\\d+")) {
            response.sendRedirect("pages.jsp?error=Invalid+Page+ID");
            return;
        }

        int pageId = Integer.parseInt(pageIdStr);

        try (Connection con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS)) {
            PreparedStatement select = con.prepareStatement("SELECT is_approved FROM pages WHERE id = ?");
            select.setInt(1, pageId);
            ResultSet rs = select.executeQuery();
            if (rs.next()) {
                boolean currentStatus = rs.getBoolean("is_approved");
                PreparedStatement update = con.prepareStatement("UPDATE pages SET is_approved = ? WHERE id = ?");
                update.setBoolean(1, !currentStatus);
                update.setInt(2, pageId);
                update.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("pages.jsp");
    }
}
