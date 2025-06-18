package dao;

import model.UserActivityScore;
import model.User;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserActivityScoreDAO {
    private static final Logger LOGGER = Logger.getLogger(UserActivityScoreDAO.class.getName());
    private final DBContext dbContext;

    public UserActivityScoreDAO() {
        this.dbContext = new DBContext();
    }

    public List<UserActivityScore> getTopUsers(int limit) throws SQLException {
        List<UserActivityScore> scores = new ArrayList<>();
        String query = "SELECT uas.id, uas.userID, uas.totalComments, uas.totalVotes, uas.ranking, " +
                      "ua.fullName, ua.username, ua.email, ua.role, ua.profilePicture " +
                      "FROM UserActivityScore uas " +
                      "JOIN UserAccount ua ON uas.userID = ua.userID " +
                      "ORDER BY uas.totalComments + uas.totalVotes DESC, uas.ranking ASC LIMIT ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setProfilePicture(rs.getString("profilePicture"));

                    UserActivityScore score = new UserActivityScore();
                    score.setId(rs.getInt("id"));
                    score.setUserId(rs.getString("userID"));
                    score.setTotalComments(rs.getInt("totalComments"));
                    score.setTotalVotes(rs.getInt("totalVotes"));
                    score.setRanking(rs.getInt("ranking"));
                    score.setUser(user);
                    scores.add(score);
                }
                LOGGER.info("Retrieved " + scores.size() + " top users");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving top users: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return scores;
    }

    public void updateVoteCount(String userId, boolean increment) throws SQLException {
        String query = "UPDATE UserActivityScore SET totalVotes = totalVotes + ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, increment ? 1 : -1);
            stmt.setString(2, userId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                String insertQuery = "INSERT INTO UserActivityScore (userID, totalComments, totalVotes, ranking) VALUES (?, 0, ?, 0)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                    insertStmt.setString(1, userId);
                    insertStmt.setInt(2, increment ? 1 : 0);
                    insertStmt.executeUpdate();
                }
            }
            LOGGER.info("Updated vote count for user: " + userId + ", increment: " + increment);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating vote count: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }
}