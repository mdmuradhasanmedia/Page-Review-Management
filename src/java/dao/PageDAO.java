package dao;

import model.Page;
import util.DBConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PageDAO {

    private final String jdbcURL = DBConfig.DB_URL;
    private final String dbUser = DBConfig.DB_USER;
    private final String dbPassword = DBConfig.DB_PASS;

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }

    // Add a new page to the database
    public boolean addPage(Page page) {
        String sql = "INSERT INTO pages (user_id, title, contact, email, location, content) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, page.getUserId());
            stmt.setString(2, page.getTitle());
            stmt.setString(3, page.getContact());
            stmt.setString(4, page.getEmail());
            stmt.setString(5, page.getLocation());
            stmt.setString(6, page.getContent());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace(); // Log error for debugging
            return false;
        }
    }

    // Retrieve all pages for a given user
    public List<Page> getPagesByUserId(int userId) {
        List<Page> pages = new ArrayList<>();
        String sql = "SELECT * FROM pages WHERE user_id = ? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Page page = new Page();
                page.setPageId(rs.getInt("id")); // ✅ fixed from "page_id"
                page.setUserId(rs.getInt("user_id"));
                page.setTitle(rs.getString("title"));
                page.setContact(rs.getString("contact"));
                page.setEmail(rs.getString("email"));
                page.setLocation(rs.getString("location"));
                page.setContent(rs.getString("content"));

                pages.add(page);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Log SQL error
        }

        return pages;
    }
}
