/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Teacher {

    private String teacherID;
    private String userID;
    private String specialization;
    private int experienceYears;

    public Teacher(String teacherID, String userID, String specialization, int experienceYears) {
        this.teacherID = teacherID;
        this.userID = userID;
        this.specialization = specialization;
        this.experienceYears = experienceYears;
    }

    public String getTeacherID() {
        return teacherID;
    }

    public void setTeacherID(String teacherID) {
        this.teacherID = teacherID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    @Override
    public String toString() {
        return "Teacher{" + "teacherID=" + teacherID + ", userID=" + userID + ", specialization=" + specialization + ", experienceYears=" + experienceYears + '}';
    }

}
