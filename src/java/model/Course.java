package model;

import java.math.BigDecimal;
import java.util.Date;

public class Course {
    private String courseId;
    private String title;
    private String description;
    private BigDecimal fee;
    private int duration;
    private Date startDate;
    private Date endDate;
    private boolean isActive;

    // Constructors
    public Course() {}

    public Course(String courseId, String title, String description, BigDecimal fee, 
                  int duration, Date startDate, Date endDate, boolean isActive) {
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.fee = fee;
        this.duration = duration;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    // Getters and Setters
    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

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
