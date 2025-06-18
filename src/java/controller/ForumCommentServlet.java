package controller;

import dao.ForumCommentDAO;
import dao.UserActivityScoreDAO;
import model.ForumComment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Logger;

@WebServlet("/forum/createComment")
public class ForumCommentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForumCommentServlet.class.getName());
    private ForumCommentDAO commentDAO;
    private UserActivityScoreDAO scoreDAO;

    @Override
    public void init() throws ServletException {
        commentDAO = new ForumCommentDAO();
        scoreDAO = new UserActivityScoreDAO();
        LOGGER.info("ForumCommentServlet initialized");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumCommentServlet doPost called");
        try {
            String userId = (String) request.getSession().getAttribute("userId");
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int postId = Integer.parseInt(request.getParameter("postId"));
            String commentText = request.getParameter("commentText");
            if (commentText == null || commentText.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nội dung bình luận không được để trống");
                return;
            }

            ForumComment comment = new ForumComment();
            comment.setPostID(postId);
            comment.setCommentText(commentText);
            comment.setCommentedBy(userId);
            comment.setCommentedDate(new Timestamp(System.currentTimeMillis()));
            comment.setVoteCount(0); // Initialize vote count

            commentDAO.createComment(comment);
            updateUserActivityScore(userId);

            request.getSession().setAttribute("message", "Bình luận đã được gửi!");
            response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu");
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid postId: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định");
        }
    }

    private void updateUserActivityScore(String userId) throws SQLException {
        scoreDAO.updateCommentCount(userId, true);
        LOGGER.info("Updated UserActivityScore for user: " + userId + " with new comment");
    }
}