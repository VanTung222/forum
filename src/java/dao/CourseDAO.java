package dao;

import model.Course;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
                      "JOIN Course_Enrollments ce ON c.courseID = ce.courseID " +
                      "JOIN Student s ON ce.studentID = s.studentID " +
                      "WHERE s.userID = ? AND c.isActive = TRUE";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    courses.add(course);
                }
            }
        } finally {
            dbContext.closeConnection();
        }
        return courses;
    }
}
