package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/JLEARNING?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root"; // Replace with your MySQL username
    private static final String PASSWORD = "123456"; // Replace with your MySQL password
    private Connection connection;

    // Constructor
    public DBContext() {
        connection = null;
    }

    // Establishes a connection to the MySQL database
    public Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                // Load the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Establish the connection
                connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
                System.out.println("Database connection established successfully.");
            } catch (ClassNotFoundException e) {
                System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
                throw new SQLException("Failed to load JDBC driver", e);
            } catch (SQLException e) {
                System.err.println("Failed to connect to database: " + e.getMessage());
                throw e;
            }
        }
        return connection;
    }

    // Closes the database connection
    public void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Database connection closed.");
                }
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            } finally {
                connection = null;
            }
        }
    }
}