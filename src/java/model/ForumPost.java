package model;

import java.sql.Timestamp;
import java.util.List;

public class ForumPost {
    private int id;
    private String title;
    private String content;
    private String postedBy;
    private Timestamp createdDate;
    private String category;
    private int viewCount;
    private int voteCount;
    private String picture;
    private int commentCount;
    private List<ForumComment> comments;

    public ForumPost() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getPostedBy() { return postedBy; }
    public void setPostedBy(String postedBy) { this.postedBy = postedBy; }
    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    public List<ForumComment> getComments() { return comments; }
    public void setComments(List<ForumComment> comments) { this.comments = comments; }
}