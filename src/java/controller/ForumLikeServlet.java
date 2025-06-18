package controller;

import dao.ForumPostDAO;
import dao.UserActivityScoreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Logger;
import org.json.JSONObject;

@WebServlet("/forum/toggleLike")
public class ForumLikeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForumLikeServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserActivityScoreDAO scoreDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        scoreDAO = new UserActivityScoreDAO();
        LOGGER.info("ForumLikeServlet initialized");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            String userId = (String) request.getSession().getAttribute("userId");
            if (userId == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng đăng nhập để thích bài viết");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(jsonResponse.toString());
                return;
            }

            int postId = Integer.parseInt(request.getParameter("postId"));
            String action = request.getParameter("action");
            boolean hasLiked = postDAO.hasUserLikedPost(postId, userId);
            int voteCount;

            if ("like".equals(action) && !hasLiked) {
                postDAO.addLike(postId, userId);
                updateUserActivityScore(userId, true);
                voteCount = getVoteCount(postId);
                jsonResponse.put("success", true);
                jsonResponse.put("voteCount", voteCount);
                LOGGER.info("User " + userId + " liked post ID: " + postId);
            } else if ("unlike".equals(action) && hasLiked) {
                postDAO.removeLike(postId, userId);
                updateUserActivityScore(userId, false);
                voteCount = getVoteCount(postId);
                jsonResponse.put("success", true);
                jsonResponse.put("voteCount", voteCount);
                LOGGER.info("User " + userId + " unliked post ID: " + postId);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", hasLiked ? "Bạn đã thích bài viết này rồi" : "Bạn chưa thích bài viết này");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(jsonResponse.toString());
                return;
            }

            out.print(jsonResponse.toString());
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid postId: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "ID bài viết không hợp lệ");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(jsonResponse.toString());
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi cơ sở dữ liệu");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(jsonResponse.toString());
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi không xác định");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(jsonResponse.toString());
        }
    }

    private int getVoteCount(int postId) throws SQLException {
        String query = "SELECT voteCount FROM ForumPost WHERE id = ?";
        try (var conn = new utils.DBContext().getConnection();
             var stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            try (var rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("voteCount");
                }
            }
        }
        return 0;
    }

    private void updateUserActivityScore(String userId, boolean isLike) throws SQLException {
        scoreDAO.updateVoteCount(userId, isLike);
        LOGGER.info("Updated UserActivityScore for user: " + userId + ", isLike: " + isLike);
    }
}