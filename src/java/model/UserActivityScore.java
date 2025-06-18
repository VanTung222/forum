package model;

public class UserActivityScore {
    private int id;
    private String userId;
    private int weeklyComments;
    private int weeklyVotes;
    private int monthlyComments;
    private int monthlyVotes;
    private int totalComments;
    private int totalVotes;
    private int totalScore; // New field for display
    private User user;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getWeeklyComments() { return weeklyComments; }
    public void setWeeklyComments(int weeklyComments) { this.weeklyComments = weeklyComments; }
    public int getWeeklyVotes() { return weeklyVotes; }
    public void setWeeklyVotes(int weeklyVotes) { this.weeklyVotes = weeklyVotes; }
    public int getMonthlyComments() { return monthlyComments; }
    public void setMonthlyComments(int monthlyComments) { this.monthlyComments = monthlyComments; }
    public int getMonthlyVotes() { return monthlyVotes; }
    public void setMonthlyVotes(int monthlyVotes) { this.monthlyVotes = monthlyVotes; }
    public int getTotalComments() { return totalComments; }
    public void setTotalComments(int totalComments) { this.totalComments = totalComments; }
    public int getTotalVotes() { return totalVotes; }
    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }
    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}