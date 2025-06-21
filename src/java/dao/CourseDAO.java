package dao;

import model.Course;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CourseDAO {
    private static final Logger LOGGER = Logger.getLogger(CourseDAO.class.getName());
    private final DBContext dbContext;

    public CourseDAO() {
        this.dbContext = new DBContext();
    }

    public List<Course> getCoursesByUserId(String userId) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT c.courseID, c.title, c.description, c.fee, c.duration, c.startDate, c.endDate, c.isActive " +
                      "FROM Courses c " +
                      "INNER JOIN Course_Enrollments ce ON c.courseID = ce.courseID " +
                      "INNER JOIN Student s ON ce.studentID = s.studentID " +
                      "WHERE s.userID = ? AND c.isActive = TRUE " +
                      "ORDER BY ce.enrollmentDate DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    courses.add(course);
                }
                LOGGER.info("Retrieved " + courses.size() + " courses for user: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving courses for user: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return courses;
    }
}
