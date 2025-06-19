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
import utils.DBContext;

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
            String userId = (String) request.getSession().getAttribute("userId");
            String username = (String) request.getSession().getAttribute("username");
            
            // Default user for testing
            if (userId == null) {
                userId = "U001";
                username = "quy123";
                request.getSession().setAttribute("userId", userId);
                request.getSession().setAttribute("username", username);
            }

            // Get user information
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get user's enrolled courses
            List<Course> enrolledCourses = courseDAO.getCoursesByUserId(userId);
            
            // Get user's forum posts
            List<ForumPost> userPosts = postDAO.getPostsByUserId(userId, 5); // Latest 5 posts
            
            // Get user activity score
            UserActivityScoreDAO scoreDAO = new UserActivityScoreDAO();
            UserActivityScore activityScore = scoreDAO.getUserActivityScore(userId);
            
            // Get user achievements
            List<Achievement> achievements = achievementDAO.getAchievementsByUserId(userId);

            // Set attributes
            request.setAttribute("user", user);
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("userPosts", userPosts);
            request.setAttribute("activityScore", activityScore);
            request.setAttribute("achievements", achievements);

            LOGGER.info("Forwarding to userProfile.jsp for user: " + userId);
            request.getRequestDispatcher("/view/userProfile.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.severe("Database error in UserProfileServlet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in UserProfileServlet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error");
        }
    }
}
