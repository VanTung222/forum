package dao;

import model.ForumComment;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ForumCommentDAO {
    private static final Logger LOGGER = Logger.getLogger(ForumCommentDAO.class.getName());
    private final DBContext dbContext;

    public ForumCommentDAO() {
        this.dbContext = new DBContext();
    }

    public List<ForumComment> getCommentsByPostId(int postId) throws SQLException {
        List<ForumComment> comments = new ArrayList<>();
        String query = "SELECT id, postID, commentText, commentedBy, commentedDate, voteCount " +
                      "FROM ForumComment WHERE postID = ? ORDER BY commentedDate ASC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumComment comment = new ForumComment();
                    comment.setId(rs.getInt("id"));
                    comment.setPostID(rs.getInt("postID"));
                    comment.setCommentText(rs.getString("commentText"));
                    comment.setCommentedBy(rs.getString("commentedBy"));
                    comment.setCommentedDate(rs.getTimestamp("commentedDate"));
                    comment.setVoteCount(rs.getInt("voteCount"));
                    comments.add(comment);
                }
                LOGGER.info("Retrieved " + comments.size() + " comments for postID: " + postId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving comments: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return comments;
    }

    public void createComment(ForumComment comment) throws SQLException {
        String query = "INSERT INTO ForumComment (postID, commentText, commentedBy, commentedDate, voteCount) " +
                      "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, comment.getPostID());
            stmt.setString(2, comment.getCommentText());
            stmt.setString(3, comment.getCommentedBy());
            stmt.setTimestamp(4, comment.getCommentedDate());
            stmt.setInt(5, comment.getVoteCount());
            stmt.executeUpdate();
            LOGGER.info("Created new comment for postID: " + comment.getPostID());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating comment: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }
}