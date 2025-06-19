package model;

import java.math.BigDecimal;
import java.sql.Date;

public class Course {
    private int courseNum;
    private String courseID;
    private String title;
    private String description;
    private BigDecimal fee;
    private int duration;
    private Date startDate;
    private Date endDate;
    private boolean isActive;

    // Constructors
    public Course() {}

    public Course(String courseID, String title, String description, BigDecimal fee, 
                 int duration, Date startDate, Date endDate, boolean isActive) {
        this.courseID = courseID;
        this.title = title;
        this.description = description;
        this.fee = fee;
        this.duration = duration;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getCourseNum() { return courseNum; }
    public void setCourseNum(int courseNum) { this.courseNum = courseNum; }

    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
