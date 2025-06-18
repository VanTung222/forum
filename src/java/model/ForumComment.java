package model;

import java.sql.Timestamp;

public class ForumComment {
    private int id;
    private int postID;
    private String commentText;
    private String commentedBy;
    private Timestamp commentedDate;
    private int voteCount;

    public ForumComment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPostID() { return postID; }
    public void setPostID(int postID) { this.postID = postID; }
    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }
    public String getCommentedBy() { return commentedBy; }
    public void setCommentedBy(String commentedBy) { this.commentedBy = commentedBy; }
    public Timestamp getCommentedDate() { return commentedDate; }
    public void setCommentedDate(Timestamp commentedDate) { this.commentedDate = commentedDate; }
    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
}