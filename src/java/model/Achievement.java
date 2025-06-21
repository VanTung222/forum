package model;

import java.util.Date;

public class Achievement {
    private int id;
    private String userId;
    private String achievementType;
    private String title;
    private String description;
    private Date achievedDate;
    private int relatedId;
    private boolean isActive;

    // Constructors
    public Achievement() {}

    public Achievement(int id, String userId, String achievementType, String title, 
                      String description, Date achievedDate, int relatedId, boolean isActive) {
        this.id = id;
        this.userId = userId;
        this.achievementType = achievementType;
        this.title = title;
        this.description = description;
        this.achievedDate = achievedDate;
        this.relatedId = relatedId;
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

    public int getRelatedId() { return relatedId; }
    public void setRelatedId(int relatedId) { this.relatedId = relatedId; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
