package model;

import java.sql.Date;

public class User {
    private String userId;
    private String username;
    private String fullName;
    private String email;
    private String password;
    private String role;
    private Date registrationDate;
    private String profilePicture;
    private String phone;
    private Date birthDate;

    public User() {}

    public User(String userId, String username, String fullName, String email, String password, 
                String role, Date registrationDate, String profilePicture, String phone, Date birthDate) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.registrationDate = registrationDate;
        this.profilePicture = profilePicture;
        this.phone = phone;
        this.birthDate = birthDate;
    }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Date getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Date registrationDate) { this.registrationDate = registrationDate; }
    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }
    
    public String getPicture() { return null; }
}