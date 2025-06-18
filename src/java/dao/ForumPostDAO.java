package dao;

import model.ForumPost;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ForumPostDAO {
    private static final Logger LOGGER = Logger.getLogger(ForumPostDAO.class.getName());
    private final DBContext dbContext;
    private final ForumCommentDAO commentDAO;

    public ForumPostDAO() {
        this.dbContext = new DBContext();
        this.commentDAO = new ForumCommentDAO();
    }

    public List<ForumPost> getPostsSortedAndFiltered(String sort, String filter, String search, int page, int size) throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT fp.id, fp.title, fp.content, fp.postedBy, fp.createdDate, fp.category, fp.viewCount, fp.voteCount, fp.picture, ua.username AS postedByUsername " +
                                              "FROM ForumPost fp LEFT JOIN UserAccount ua ON fp.postedBy = ua.userID ");
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        // Handle search by title
        if (search != null && !search.trim().isEmpty()) {
            conditions.add("fp.title LIKE ?");
            parameters.add("%" + search.trim() + "%");
        }

        // Handle filter conditions
        if ("with-replies".equals(filter)) {
            conditions.add("fp.id IN (SELECT postID FROM ForumComment)");
        } else if ("no-replies".equals(filter)) {
            conditions.add("fp.id NOT IN (SELECT postID FROM ForumComment)");
        }

        // Combine conditions
        if (!conditions.isEmpty()) {
            query.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }

        // Handle sorting
        if ("newest".equals(sort)) {
            query.append("ORDER BY fp.createdDate DESC ");
        } else if ("popular".equals(sort)) {
            query.append("ORDER BY fp.viewCount DESC ");
        } else if ("most-liked".equals(sort)) {
            query.append("ORDER BY fp.voteCount DESC ");
        } else {
            query.append("ORDER BY fp.createdDate DESC ");
        }
        query.append("LIMIT ? OFFSET ?");

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            stmt.setInt(parameters.size() + 1, size);
            stmt.setInt(parameters.size() + 2, (page - 1) * size);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));

                    String commentCountQuery = "SELECT COUNT(*) AS commentCount FROM ForumComment WHERE postID = ?";
                    try (PreparedStatement countStmt = conn.prepareStatement(commentCountQuery)) {
                        countStmt.setInt(1, post.getId());
                        try (ResultSet countRs = countStmt.executeQuery()) {
                            if (countRs.next()) {
                                post.setCommentCount(countRs.getInt("commentCount"));
                            }
                        }
                    }

                    post.setComments(commentDAO.getCommentsByPostId(post.getId()));
                    posts.add(post);
                }
                LOGGER.info("Retrieved " + posts.size() + " posts");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving posts: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return posts;
    }

    public ForumPost getPostById(int postId) throws SQLException {
        ForumPost post = null;
        String query = "SELECT fp.id, fp.title, fp.content, fp.postedBy, fp.createdDate, fp.category, fp.viewCount, fp.voteCount, fp.picture, ua.username AS postedByUsername " +
                      "FROM ForumPost fp LEFT JOIN UserAccount ua ON fp.postedBy = ua.userID WHERE fp.id = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));

                    String commentCountQuery = "SELECT COUNT(*) AS commentCount FROM ForumComment WHERE postID = ?";
                    try (PreparedStatement countStmt = conn.prepareStatement(commentCountQuery)) {
                        countStmt.setInt(1, post.getId());
                        try (ResultSet countRs = countStmt.executeQuery()) {
                            if (countRs.next()) {
                                post.setCommentCount(countRs.getInt("commentCount"));
                            }
                        }
                    }

                    post.setComments(commentDAO.getCommentsByPostId(post.getId()));
                }
                LOGGER.info("Retrieved post with ID: " + postId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving post: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return post;
    }

    public void incrementViewCount(int postId) throws SQLException {
        String query = "UPDATE ForumPost SET viewCount = viewCount + 1 WHERE id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            stmt.executeUpdate();
            LOGGER.info("Incremented view count for post ID: " + postId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing view count: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }

    public void addLike(int postId, String userId) throws SQLException {
        String checkQuery = "SELECT COUNT(*) FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        String insertQuery = "INSERT INTO ForumCommentVote (postID, userID, voteValue, voteDate) VALUES (?, ?, 1, NOW())";
        String updateQuery = "UPDATE ForumPost SET voteCount = voteCount + 1 WHERE id = ?";

        Connection conn = dbContext.getConnection();
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, postId);
                checkStmt.setString(2, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        conn.rollback();
                        LOGGER.info("User " + userId + " has already liked post ID: " + postId);
                        return;
                    }
                }
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setInt(1, postId);
                insertStmt.setString(2, userId);
                insertStmt.executeUpdate();
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setInt(1, postId);
                updateStmt.executeUpdate();
            }

            conn.commit();
            LOGGER.info("Added like for post ID: " + postId + " by user: " + userId);
        } catch (SQLException e) {
            conn.rollback();
            LOGGER.log(Level.SEVERE, "Error adding like: " + e.getMessage(), e);
            throw e;
        } finally {
            conn.setAutoCommit(true);
            dbContext.closeConnection();
        }
    }

    public void removeLike(int postId, String userId) throws SQLException {
        String deleteQuery = "DELETE FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        String updateQuery = "UPDATE ForumPost SET voteCount = voteCount - 1 WHERE id = ?";

        Connection conn = dbContext.getConnection();
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
                deleteStmt.setInt(1, postId);
                deleteStmt.setString(2, userId);
                deleteStmt.executeUpdate();
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setInt(1, postId);
                updateStmt.executeUpdate();
            }

            conn.commit();
            LOGGER.info("Removed like for post ID: " + postId + " by user: " + userId);
        } catch (SQLException e) {
            conn.rollback();
            LOGGER.log(Level.SEVERE, "Error removing like: " + e.getMessage(), e);
            throw e;
        } finally {
            conn.setAutoCommit(true);
            dbContext.closeConnection();
        }
    }

    public boolean hasUserLikedPost(int postId, String userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            stmt.setString(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking like status: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return false;
    }

    public void createPost(ForumPost post) throws SQLException {
        String query = "INSERT INTO ForumPost (title, content, postedBy, createdDate, category, viewCount, voteCount, picture) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setString(3, post.getPostedBy());
            stmt.setTimestamp(4, post.getCreatedDate());
            stmt.setString(5, post.getCategory());
            stmt.setInt(6, post.getViewCount());
            stmt.setInt(7, post.getVoteCount());
            stmt.setString(8, post.getPicture());
            stmt.executeUpdate();
            LOGGER.info("Created new post: " + post.getTitle());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating post: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }
    
    // Update post
    public boolean updatePost(ForumPost post) {
        String sql = "UPDATE ForumPost SET title = ?, content = ?, category = ?, picture = ? WHERE id = ? AND postedBy = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getCategory());
            ps.setString(4, post.getPicture());
            ps.setInt(5, post.getId());
            ps.setString(6, post.getPostedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete post
    public boolean deletePost(int postId, String userId) {
        String sql = "DELETE FROM ForumPost WHERE id = ? AND postedBy = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ForumPost> getRelatedPosts(int postId, String category, int limit) throws SQLException {
        List<ForumPost> related = new ArrayList<>();
        String query = "SELECT id, title, content, postedBy, createdDate, category, viewCount, voteCount, picture " +
                       "FROM ForumPost WHERE category = ? AND id <> ? ORDER BY createdDate DESC LIMIT ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            stmt.setInt(2, postId);
            stmt.setInt(3, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    related.add(post);
                }
            }
        } finally {
            dbContext.closeConnection();
        }
        return related;
    }
}