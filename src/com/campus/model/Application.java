package com.campus.model;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int driveId;
    private int studentId;
    private String status;
    private String coverLetter;
    private Timestamp appliedAt;
    private Timestamp updatedAt;

    // Joined fields
    private String studentName;
    private String studentEmail;
    private String studentPhone;
    private String studentDepartment;
    private String studentBatch;
    private String studentRollNumber;
    private double studentCgpa;
    private double studentTenthPercent;
    private double studentTwelfthPercent;
    private double studentGradPercent;
    private double studentMastersPercent;
    private String studentSkills;
    private String studentResumePath;
    private String driveTitle;
    private String companyName;
    private String driveRole;

    public Application() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDriveId() { return driveId; }
    public void setDriveId(int driveId) { this.driveId = driveId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCoverLetter() { return coverLetter; }
    public void setCoverLetter(String coverLetter) { this.coverLetter = coverLetter; }
    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }
    public String getStudentDepartment() { return studentDepartment; }
    public void setStudentDepartment(String studentDepartment) { this.studentDepartment = studentDepartment; }
    public String getStudentBatch() { return studentBatch; }
    public void setStudentBatch(String studentBatch) { this.studentBatch = studentBatch; }
    public String getStudentRollNumber() { return studentRollNumber; }
    public void setStudentRollNumber(String rollNumber) { this.studentRollNumber = rollNumber; }
    public double getStudentCgpa() { return studentCgpa; }
    public void setStudentCgpa(double studentCgpa) { this.studentCgpa = studentCgpa; }
    public double getStudentTenthPercent() { return studentTenthPercent; }
    public void setStudentTenthPercent(double v) { this.studentTenthPercent = v; }
    public double getStudentTwelfthPercent() { return studentTwelfthPercent; }
    public void setStudentTwelfthPercent(double v) { this.studentTwelfthPercent = v; }
    public double getStudentGradPercent() { return studentGradPercent; }
    public void setStudentGradPercent(double v) { this.studentGradPercent = v; }
    public double getStudentMastersPercent() { return studentMastersPercent; }
    public void setStudentMastersPercent(double v) { this.studentMastersPercent = v; }
    public String getStudentSkills() { return studentSkills; }
    public void setStudentSkills(String studentSkills) { this.studentSkills = studentSkills; }
    public String getStudentResumePath() { return studentResumePath; }
    public void setStudentResumePath(String studentResumePath) { this.studentResumePath = studentResumePath; }
    public String getDriveTitle() { return driveTitle; }
    public void setDriveTitle(String driveTitle) { this.driveTitle = driveTitle; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getDriveRole() { return driveRole; }
    public void setDriveRole(String driveRole) { this.driveRole = driveRole; }
}
