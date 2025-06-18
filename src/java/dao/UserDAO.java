
package dao;

import model.User;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = new DBContext();
    }

    public User getUserByUsername(String username) throws SQLException {
        User user = null;
        String query = "SELECT userID, username, fullName, email, password, role, registrationDate, " +
                      "profilePicture, phone, birthDate FROM UserAccount WHERE username = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                }
                LOGGER.info("Retrieved user: " + (user != null ? user.getUsername() : "null"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return user;
    }
    
    public String getUsernameByUserID(String userID) throws SQLException {
        String username = "Unknown";
        String query = "SELECT username FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("username");
                }
            }
        } finally {
            dbContext.closeConnection();
        }
        return username;
    }
}