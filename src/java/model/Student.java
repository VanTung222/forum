package model;

import java.time.LocalDate;
import java.util.List;

public class Student {

    private String studentID;
    private String userID;
    private LocalDate enrollmentDate;
    private List progress;
    private String level;

    public Student(String studentID, String userID, LocalDate enrollmentDate, List progress, String level) {
        this.studentID = studentID;
        this.userID = userID;
        this.enrollmentDate = enrollmentDate;
        this.progress = progress;
        this.level = level;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public LocalDate getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(LocalDate enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public List getProgress() {
        return progress;
    }

    public void setProgress(List progress) {
        this.progress = progress;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    @Override
    public String toString() {
        return "Student{" + "studentID=" + studentID + ", userID=" + userID + ", enrollmentDate=" + enrollmentDate + ", progress=" + progress + ", level=" + level + '}';
    }

}
