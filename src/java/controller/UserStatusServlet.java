package controller;

import util.DBConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/UserStatusServlet")
public class UserStatusServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String search = request.getParameter("search");
        String page = request.getParameter("page");
        
        if (action == null || idStr == null) {
            response.sendRedirect("users.jsp?msg=invalid");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS);
            String sql = null;
            if ("suspend".equals(action)) {
                sql = "UPDATE users SET is_suspended=1 WHERE id=?";
            } else if ("activate".equals(action)) {
                sql = "UPDATE users SET is_suspended=0 WHERE id=?";
            }
            if (sql != null) {
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setInt(1, id);
                pst.executeUpdate();
                pst.close();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect with search & page if present
        String url = "users.jsp";
        boolean hasParam = false;
        if (search != null && !search.isEmpty()) {
            url += "?search=" + java.net.URLEncoder.encode(search, "UTF-8");
            hasParam = true;
        }
        if (page != null && !page.isEmpty()) {
            url += (hasParam ? "&" : "?") + "page=" + page;
        }
        response.sendRedirect(url);
    }
}
