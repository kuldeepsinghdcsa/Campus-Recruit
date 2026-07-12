package com.campus.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Student {
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private Date dob;
    private String gender;
    private String address;
    private String department;
    private String batch;
    private String rollNumber;
    private double cgpa;
    private double tenthPercent;
    private double twelfthPercent;
    private double gradPercent;
    private double mastersPercent;
    private String skills;
    private String resumePath;
    private boolean profileComplete;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Student() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getBatch() { return batch; }
    public void setBatch(String batch) { this.batch = batch; }
    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }
    public double getTenthPercent() { return tenthPercent; }
    public void setTenthPercent(double tenthPercent) { this.tenthPercent = tenthPercent; }
    public double getTwelfthPercent() { return twelfthPercent; }
    public void setTwelfthPercent(double twelfthPercent) { this.twelfthPercent = twelfthPercent; }
    public double getGradPercent() { return gradPercent; }
    public void setGradPercent(double gradPercent) { this.gradPercent = gradPercent; }
    public double getMastersPercent() { return mastersPercent; }
    public void setMastersPercent(double mastersPercent) { this.mastersPercent = mastersPercent; }
    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
    public String getResumePath() { return resumePath; }
    public void setResumePath(String resumePath) { this.resumePath = resumePath; }
    public boolean isProfileComplete() { return profileComplete; }
    public void setProfileComplete(boolean profileComplete) { this.profileComplete = profileComplete; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
