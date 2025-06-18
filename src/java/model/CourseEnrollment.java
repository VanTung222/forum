
package model;

public class CourseEnrollment {

    private int id;
    private String studentID;
    private int courseID;
    private String enrollmentDate;
    private double progress;
    private String completionDate;

    public CourseEnrollment(int id, String studentID, int courseID, String enrollmentDate, double progress, String completionDate) {
        this.id = id;
        this.studentID = studentID;
        this.courseID = courseID;
        this.enrollmentDate = enrollmentDate;
        this.progress = progress;
        this.completionDate = completionDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(String enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public double getProgress() {
        return progress;
    }

    public void setProgress(double progress) {
        this.progress = progress;
    }

    public String getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(String completionDate) {
        this.completionDate = completionDate;
    }

    @Override
    public String toString() {
        return "CourseEnrollment{" + "id=" + id + ", studentID=" + studentID + ", courseID=" + courseID + ", enrollmentDate=" + enrollmentDate + ", progress=" + progress + ", completionDate=" + completionDate + '}';
    }

}
