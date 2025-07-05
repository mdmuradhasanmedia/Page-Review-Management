package util;

import java.sql.*;
import java.util.HashSet;
import java.util.Set;

public class DBInitializer {

    private static final String ROOT_URL = DBConfig.ROOT_URL;
    private static final String DB_URL = DBConfig.DB_URL;
    private static final String DB_USER = DBConfig.DB_USER;
    private static final String DB_PASS = DBConfig.DB_PASS;

    public static void initialize() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded.");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            return;
        }

        // Step 1: Test root connection
        try (Connection con = DriverManager.getConnection(ROOT_URL, DB_USER, DB_PASS)) {
            System.out.println("MySQL connection OK.");
        } catch (SQLException e) {
            System.err.println("FATAL: Cannot connect to MySQL. Check credentials/server.");
            e.printStackTrace();
            return;
        }

        // Step 2: Create DB if not exists
        try (Connection con = DriverManager.getConnection(ROOT_URL, DB_USER, DB_PASS); Statement st = con.createStatement()) {
            st.executeUpdate("CREATE DATABASE IF NOT EXISTS pagereviewmanagement");
            System.out.println("Database checked/created.");
        } catch (SQLException e) {
            System.err.println("Error creating database:");
            e.printStackTrace();
            return;
        }

        // Step 3: Validate/Create tables
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS); Statement st = con.createStatement()) {

            System.out.println("---- DBInitializer: Checking tables ----");

            String[] userCols = {"id", "username", "email", "password", "full_name", "is_suspended"};
            String[] adminCols = {"id", "username", "password"};
            String[] pageCols = {"id", "user_id", "title", "contact", "email", "location", "content", "created_at", "is_approved"};
            String[] reviewCols = {"id", "user_id", "page_id", "name", "email", "stars", "comment", "created_at", "is_approved"};

            // Recreate in child-to-parent order to handle FKs
            checkOrRecreateTable(con, st, "reviews", reviewCols,
                "CREATE TABLE reviews (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "user_id INT," +
                "page_id INT," +
                "name VARCHAR(100) NOT NULL," +
                "email VARCHAR(100) NOT NULL," +
                "stars INT NOT NULL," +
                "comment TEXT NOT NULL," +
                "created_at DATETIME DEFAULT CURRENT_TIMESTAMP," +
                "is_approved BOOLEAN DEFAULT FALSE," +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL," +
                "FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE)"
            );

            checkOrRecreateTable(con, st, "pages", pageCols,
                "CREATE TABLE pages (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "user_id INT," +
                "title VARCHAR(255)," +
                "contact VARCHAR(100)," +
                "email VARCHAR(100)," +
                "location VARCHAR(255)," +
                "content TEXT," +
                "created_at DATETIME DEFAULT CURRENT_TIMESTAMP," +
                "is_approved BOOLEAN DEFAULT FALSE," +
                "FOREIGN KEY (user_id) REFERENCES users(id))"
            );

            checkOrRecreateTable(con, st, "users", userCols,
                "CREATE TABLE users (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "username VARCHAR(50) UNIQUE NOT NULL," +
                "email VARCHAR(100) UNIQUE NOT NULL," +
                "password VARCHAR(255) NOT NULL," +
                "full_name VARCHAR(100)," +
                "is_suspended BOOLEAN DEFAULT FALSE)"
            );

            checkOrRecreateTable(con, st, "admin", adminCols,
                "CREATE TABLE admin (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "username VARCHAR(50) UNIQUE NOT NULL," +
                "password VARCHAR(255) NOT NULL)"
            );

            // Create default admin user
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM admin WHERE username='admin'");
            if (rs.next() && rs.getInt(1) == 0) {
                st.executeUpdate("INSERT INTO admin (username, password) VALUES ('admin', 'admin123')");
                System.out.println("Default admin created: admin / admin123");
            } else {
                System.out.println("Admin user already exists.");
            }

            System.out.println("DB Initialization completed.");

        } catch (SQLException e) {
            System.err.println("Final DB init error:");
            e.printStackTrace();
        }
    }

    private static void checkOrRecreateTable(Connection con, Statement st, String tableName, String[] expectedCols, String createSQL) throws SQLException {
        if (!tableMatchesSchema(con, tableName, expectedCols)) {
            System.out.println("Table '" + tableName + "' schema mismatch. Recreating...");
            try {
                st.execute("SET FOREIGN_KEY_CHECKS = 0");
                st.executeUpdate("DROP TABLE IF EXISTS " + tableName);
                st.execute("SET FOREIGN_KEY_CHECKS = 1");
                st.executeUpdate(createSQL);
                System.out.println("Table '" + tableName + "' created.");
            } catch (SQLException e) {
                System.err.println("Error dropping/creating table: " + tableName);
                throw e;
            }
        } else {
            System.out.println("Table '" + tableName + "' already valid.");
        }
    }

    private static boolean tableMatchesSchema(Connection con, String tableName, String[] requiredCols) throws SQLException {
        ResultSet rs = con.getMetaData().getColumns(null, null, tableName, null);
        Set<String> actualCols = new HashSet<>();
        while (rs.next()) {
            actualCols.add(rs.getString("COLUMN_NAME").toLowerCase());
        }
        for (String col : requiredCols) {
            if (!actualCols.contains(col.toLowerCase())) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        initialize();
    }
}
