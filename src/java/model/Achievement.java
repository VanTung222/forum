package model;

import java.sql.Date;

public class Achievement {
    private int id;
    private String userId;
    private String achievementType;
    private String title;
    private String description;
    private Date achievedDate;
    private int relatedID;
    private boolean isActive;

    // Constructors
    public Achievement() {}

    public Achievement(String userId, String achievementType, String title, 
                      String description, Date achievedDate, int relatedID, boolean isActive) {
        this.userId = userId;
        this.achievementType = achievementType;
        this.title = title;
        this.description = description;
        this.achievedDate = achievedDate;
        this.relatedID = relatedID;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getAchievementType() { return achievementType; }
    public void setAchievementType(String achievementType) { this.achievementType = achievementType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getAchievedDate() { return achievedDate; }
    public void setAchievedDate(Date achievedDate) { this.achievedDate = achievedDate; }

    public int getRelatedID() { return relatedID; }
    public void setRelatedID(int relatedID) { this.relatedID = relatedID; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
