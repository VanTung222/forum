package dao;

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PostViewDAO {
    private static final Logger LOGGER = Logger.getLogger(PostViewDAO.class.getName());
    private final DBContext dbContext;

    public PostViewDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Mark a post as viewed by a user
     */
    public void markPostAsViewed(String userId, int postId) throws SQLException {
        String query = "INSERT INTO PostViews (userID, postID, viewedDate) VALUES (?, ?, NOW()) " +
                      "ON DUPLICATE KEY UPDATE viewedDate = NOW()";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            stmt.setInt(2, postId);
            stmt.executeUpdate();
            LOGGER.info("Marked post " + postId + " as viewed by user " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking post as viewed: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }

    /**
     * Check if a user has viewed a specific post
     */
    public boolean hasUserViewedPost(String userId, int postId) throws SQLException {
        String query = "SELECT COUNT(*) FROM PostViews WHERE userID = ? AND postID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            stmt.setInt(2, postId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user viewed post: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return false;
    }

    /**
     * Get all post IDs that a user has viewed
     */
    public Set<Integer> getViewedPostIds(String userId) throws SQLException {
        Set<Integer> viewedPosts = new HashSet<>();
        String query = "SELECT postID FROM PostViews WHERE userID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    viewedPosts.add(rs.getInt("postID"));
                }
            }
            LOGGER.info("Retrieved " + viewedPosts.size() + " viewed posts for user " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting viewed posts: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return viewedPosts;
    }

    /**
     * Get the count of users who have viewed a specific post
     */
    public int getPostViewCount(int postId) throws SQLException {
        String query = "SELECT COUNT(DISTINCT userID) FROM PostViews WHERE postID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting post view count: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return 0;
    }

    /**
     * Remove a post view record (for testing purposes)
     */
    public void removePostView(String userId, int postId) throws SQLException {
        String query = "DELETE FROM PostViews WHERE userID = ? AND postID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            stmt.setInt(2, postId);
            stmt.executeUpdate();
            LOGGER.info("Removed post view for user " + userId + " and post " + postId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing post view: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }
}
