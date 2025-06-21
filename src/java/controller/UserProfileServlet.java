package controller;

import dao.UserDAO;
import dao.ForumPostDAO;
import dao.UserActivityScoreDAO;
import dao.CourseDAO;
import dao.AchievementDAO;
import model.User;
import model.ForumPost;
import model.UserActivityScore;
import model.Course;
import model.Achievement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/profile"})
public class UserProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserProfileServlet.class.getName());
    private UserDAO userDAO;
    private ForumPostDAO postDAO;
    private UserActivityScoreDAO scoreDAO;
    private CourseDAO courseDAO;
    private AchievementDAO achievementDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        postDAO = new ForumPostDAO();
        scoreDAO = new UserActivityScoreDAO();
        courseDAO = new CourseDAO();
        achievementDAO = new AchievementDAO();
        LOGGER.info("UserProfileServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get current logged-in user info
            String currentUserId = (String) request.getSession().getAttribute("userId");
            String currentUsername = (String) request.getSession().getAttribute("username");
            
            // Default user for testing if no session
            if (currentUserId == null) {
                currentUserId = "U001";
                currentUsername = "quy123";
                request.getSession().setAttribute("userId", currentUserId);
                request.getSession().setAttribute("username", currentUsername);
            }

            // Get target user ID from parameter (for viewing other user's profile)
            String targetUserId = request.getParameter("userId");
            
            // If no userId parameter provided, show current user's profile
            if (targetUserId == null || targetUserId.trim().isEmpty()) {
                targetUserId = currentUserId;
            }

            LOGGER.info("Viewing profile for userId: " + targetUserId + " by user: " + currentUserId);

            // Get target user information
            User targetUser = userDAO.getUserById(targetUserId);
            if (targetUser == null) {
                LOGGER.warning("User not found: " + targetUserId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Người dùng không tồn tại");
                return;
            }

            // Get target user's enrolled courses
            List<Course> enrolledCourses = null;
            try {
                enrolledCourses = courseDAO.getCoursesByUserId(targetUserId);
            } catch (Exception e) {
                LOGGER.warning("Could not load courses for user " + targetUserId + ": " + e.getMessage());
                enrolledCourses = new java.util.ArrayList<>();
            }
            
            // Get target user's forum posts
            List<ForumPost> userPosts = postDAO.getPostsByUserId(targetUserId, 5); // Latest 5 posts
            
            // Get target user activity score
            UserActivityScore activityScore = scoreDAO.getUserActivityScore(targetUserId);
            
            // Get target user achievements
            List<Achievement> achievements = null;
            try {
                achievements = achievementDAO.getAchievementsByUserId(targetUserId);
            } catch (Exception e) {
                LOGGER.warning("Could not load achievements for user " + targetUserId + ": " + e.getMessage());
                achievements = new java.util.ArrayList<>();
            }

            // Set attributes
            request.setAttribute("user", targetUser);
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("userPosts", userPosts);
            request.setAttribute("activityScore", activityScore);
            request.setAttribute("achievements", achievements);
            
            // Set flag to indicate if viewing own profile or someone else's
            request.setAttribute("isOwnProfile", currentUserId.equals(targetUserId));
            request.setAttribute("currentUser", userDAO.getUserById(currentUserId));

            LOGGER.info("Forwarding to userProfile.jsp for user: " + targetUserId);
            request.getRequestDispatcher("/view/userProfile.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.severe("Database error in UserProfileServlet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in UserProfileServlet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định");
        }
    }
}
