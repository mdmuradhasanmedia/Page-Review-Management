package user;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        int score = Integer.parseInt(request.getParameter("score"));
        String review = request.getParameter("review");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            PreparedStatement check = conn.prepareStatement("SELECT * FROM ratings WHERE user_id = ? AND movie_id = ?");
            check.setInt(1, userId);
            check.setInt(2, movieId);
            ResultSet rs = check.executeQuery();

            if (!rs.next()) {
                PreparedStatement rating = conn.prepareStatement("INSERT INTO ratings (user_id, movie_id, score, created_at) VALUES (?, ?, ?, NOW())");
                rating.setInt(1, userId);
                rating.setInt(2, movieId);
                rating.setInt(3, score);
                rating.executeUpdate();

                PreparedStatement reviewStmt = conn.prepareStatement("INSERT INTO reviews (user_id, movie_id, review, created_at) VALUES (?, ?, ?, NOW())");
                reviewStmt.setInt(1, userId);
                reviewStmt.setInt(2, movieId);
                reviewStmt.setString(3, review);
                reviewStmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("movies?movieId=" + movieId);
    }
}
