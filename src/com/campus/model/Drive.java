package com.campus.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Drive {
    private int id;
    private int companyId;
    private int adminId;
    private String title;
    private String description;
    private String role;
    private String salary;
    private String location;
    private String driveType;
    private double minCgpa;
    private double minTenth;
    private double minTwelfth;
    private double minGrad;
    private String eligibleBatches;
    private String eligibleBranches;
    private String status;
    private Date applicationDeadline;
    private Date driveDate;
    private String createdBy;
    private int approvedBy;
    private Timestamp approvedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined fields
    private String companyName;
    private String companyIndustry;
    private int applicationCount;
    private int eligibleCount;
    private boolean isApplied;
    private boolean isEligible;

    public Drive() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getSalary() { return salary; }
    public void setSalary(String salary) { this.salary = salary; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getDriveType() { return driveType; }
    public void setDriveType(String driveType) { this.driveType = driveType; }
    public double getMinCgpa() { return minCgpa; }
    public void setMinCgpa(double minCgpa) { this.minCgpa = minCgpa; }
    public double getMinTenth() { return minTenth; }
    public void setMinTenth(double minTenth) { this.minTenth = minTenth; }
    public double getMinTwelfth() { return minTwelfth; }
    public void setMinTwelfth(double minTwelfth) { this.minTwelfth = minTwelfth; }
    public double getMinGrad() { return minGrad; }
    public void setMinGrad(double minGrad) { this.minGrad = minGrad; }
    public String getEligibleBatches() { return eligibleBatches; }
    public void setEligibleBatches(String eligibleBatches) { this.eligibleBatches = eligibleBatches; }
    public String getEligibleBranches() { return eligibleBranches; }
    public void setEligibleBranches(String eligibleBranches) { this.eligibleBranches = eligibleBranches; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getApplicationDeadline() { return applicationDeadline; }
    public void setApplicationDeadline(Date applicationDeadline) { this.applicationDeadline = applicationDeadline; }
    public Date getDriveDate() { return driveDate; }
    public void setDriveDate(Date driveDate) { this.driveDate = driveDate; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public int getApprovedBy() { return approvedBy; }
    public void setApprovedBy(int approvedBy) { this.approvedBy = approvedBy; }
    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getCompanyIndustry() { return companyIndustry; }
    public void setCompanyIndustry(String companyIndustry) { this.companyIndustry = companyIndustry; }
    public int getApplicationCount() { return applicationCount; }
    public void setApplicationCount(int applicationCount) { this.applicationCount = applicationCount; }
    public int getEligibleCount() { return eligibleCount; }
    public void setEligibleCount(int eligibleCount) { this.eligibleCount = eligibleCount; }
    public boolean isApplied() { return isApplied; }
    public void setApplied(boolean applied) { isApplied = applied; }
    public boolean isEligible() { return isEligible; }
    public void setEligible(boolean eligible) { isEligible = eligible; }
}
