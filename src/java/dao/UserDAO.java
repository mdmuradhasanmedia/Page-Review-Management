package dao;

import model.User;
import util.DBUtil;
import java.sql.*;

public class UserDAO {
    // Register new user
    public boolean register(User user) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO users (username, email, password, full_name) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Login with username/email and password
    public User login(String usernameOrEmail, String password) {
        User user = null;
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users WHERE (username=? OR email=?) AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("full_name"));
                user.setSuspended(rs.getBoolean("is_suspended"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}
