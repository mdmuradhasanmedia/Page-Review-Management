package admin;

import util.DBConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ReviewActionServlet")
public class ReviewActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String id = request.getParameter("id");
        String action = request.getParameter("action");

        if (id != null && id.matches("\\d+") && action != null) {
            try (Connection con = DriverManager.getConnection(DBConfig.DB_URL, DBConfig.DB_USER, DBConfig.DB_PASS)) {
                PreparedStatement pst = null;
                if ("approve".equals(action)) {
                    pst = con.prepareStatement("UPDATE reviews SET is_approved = 1 WHERE id = ?");
                } else if ("unapprove".equals(action)) {
                    pst = con.prepareStatement("UPDATE reviews SET is_approved = 0 WHERE id = ?");
                }

                if (pst != null) {
                    pst.setInt(1, Integer.parseInt(id));
                    int rows = pst.executeUpdate();
                    pst.close();
                    if (rows > 0) {
                        response.getWriter().write("success");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.getWriter().write("fail");
    }
}
