package model;

public class UserActivityScore {
    private int id;
    private String userId;
    private int totalComments;
    private int totalVotes;
    private int ranking;
    private User user; // Changed from UserAccount to User

    public UserActivityScore() {}

    public UserActivityScore(int id, String userId, int totalComments, int totalVotes, int ranking) {
        this.id = id;
        this.userId = userId;
        this.totalComments = totalComments;
        this.totalVotes = totalVotes;
        this.ranking = ranking;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getTotalComments() { return totalComments; }
    public void setTotalComments(int totalComments) { this.totalComments = totalComments; }
    public int getTotalVotes() { return totalVotes; }
    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }
    public int getRanking() { return ranking; }
    public void setRanking(int ranking) { this.ranking = ranking; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public String getTotalLikes() { return null; }
}