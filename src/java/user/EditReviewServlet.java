package user;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditReviewServlet extends HttpServlet {
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
            PreparedStatement updateRating = conn.prepareStatement("UPDATE ratings SET score = ?, created_at = NOW() WHERE user_id = ? AND movie_id = ?");
            updateRating.setInt(1, score);
            updateRating.setInt(2, userId);
            updateRating.setInt(3, movieId);
            updateRating.executeUpdate();

            PreparedStatement updateReview = conn.prepareStatement("UPDATE reviews SET review = ?, created_at = NOW() WHERE user_id = ? AND movie_id = ?");
            updateReview.setString(1, review);
            updateReview.setInt(2, userId);
            updateReview.setInt(3, movieId);
            updateReview.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("myreviews");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int movieId = Integer.parseInt(request.getParameter("movieId"));

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "password")) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT m.title, r.score, rv.review FROM movies m " +
                "JOIN ratings r ON m.movie_id = r.movie_id " +
                "JOIN reviews rv ON m.movie_id = rv.movie_id AND r.user_id = rv.user_id " +
                "WHERE m.movie_id = ? AND r.user_id = ?");
            stmt.setInt(1, movieId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("movieId", movieId);
                request.setAttribute("movieTitle", rs.getString("title"));
                request.setAttribute("score", rs.getInt("score"));
                request.setAttribute("review", rs.getString("review"));
                request.getRequestDispatcher("user/edit_review.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("myreviews");
    }
}
