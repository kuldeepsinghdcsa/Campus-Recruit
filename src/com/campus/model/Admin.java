package com.campus.model;

import java.sql.Timestamp;

public class Admin {
    private int id;
    private String name;
    private String email;
    private String password;
    private String department;
    private String university;
    private Timestamp createdAt;

    public Admin() {}

    public Admin(int id, String name, String email, String department, String university) {
        this.id = id; this.name = name; this.email = email;
        this.department = department; this.university = university;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
