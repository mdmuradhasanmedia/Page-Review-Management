package user;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class MyReviewsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        List<HashMap<String, Object>> reviews = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            String sql = "SELECT m.movie_id, m.title, r.score, rv.review FROM movies m " +
                         "JOIN ratings r ON m.movie_id = r.movie_id " +
                         "JOIN reviews rv ON m.movie_id = rv.movie_id AND r.user_id = rv.user_id " +
                         "WHERE r.user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                HashMap<String, Object> review = new HashMap<>();
                review.put("movie_id", rs.getInt("movie_id"));
                review.put("title", rs.getString("title"));
                review.put("score", rs.getInt("score"));
                review.put("review", rs.getString("review"));
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("user/my_review.jsp").forward(request, response);
    }
}
