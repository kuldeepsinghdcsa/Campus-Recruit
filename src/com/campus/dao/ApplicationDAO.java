package com.campus.dao;

import com.campus.model.Application;
import com.campus.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean apply(int driveId, int studentId, String coverLetter) {
        String sql = "INSERT IGNORE INTO applications (drive_id,student_id,cover_letter) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId); ps.setInt(2, studentId); ps.setString(3, coverLetter);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean hasApplied(int driveId, int studentId) {
        String sql = "SELECT id FROM applications WHERE drive_id=? AND student_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId); ps.setInt(2, studentId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE applications SET status=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Application> getByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, d.title AS drive_title, d.role AS drive_role, COALESCE(c.name,'University') AS company_name " +
                     "FROM applications a JOIN drives d ON a.drive_id=d.id " +
                     "LEFT JOIN companies c ON d.company_id=c.id " +
                     "WHERE a.student_id=? ORDER BY a.applied_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setId(rs.getInt("id"));
                app.setDriveId(rs.getInt("drive_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setDriveTitle(rs.getString("drive_title"));
                app.setDriveRole(rs.getString("drive_role"));
                app.setCompanyName(rs.getString("company_name"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> getByDrive(int driveId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.name AS student_name, s.email AS student_email, s.phone AS student_phone," +
                     "s.department AS student_department, s.batch AS student_batch, s.roll_number AS student_roll_number," +
                     "s.cgpa AS student_cgpa, s.tenth_percent, s.twelfth_percent, s.grad_percent, s.masters_percent," +
                     "s.skills AS student_skills, s.resume_path AS student_resume_path " +
                     "FROM applications a JOIN students s ON a.student_id=s.id " +
                     "WHERE a.drive_id=? ORDER BY a.applied_at ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setId(rs.getInt("id"));
                app.setDriveId(rs.getInt("drive_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setStudentName(rs.getString("student_name"));
                app.setStudentEmail(rs.getString("student_email"));
                app.setStudentPhone(rs.getString("student_phone"));
                app.setStudentDepartment(rs.getString("student_department"));
                app.setStudentBatch(rs.getString("student_batch"));
                app.setStudentRollNumber(rs.getString("student_roll_number"));
                app.setStudentCgpa(rs.getDouble("student_cgpa"));
                app.setStudentTenthPercent(rs.getDouble("tenth_percent"));
                app.setStudentTwelfthPercent(rs.getDouble("twelfth_percent"));
                app.setStudentGradPercent(rs.getDouble("grad_percent"));
                app.setStudentMastersPercent(rs.getDouble("masters_percent"));
                app.setStudentSkills(rs.getString("student_skills"));
                app.setStudentResumePath(rs.getString("student_resume_path"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalApplications() {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM applications")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Placement statistics by company (for admin dashboard)
    public List<Object[]> getPlacementByCompany() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT COALESCE(c.name,'University Drive') AS company, COUNT(a.id) AS total, " +
                     "SUM(CASE WHEN a.status='selected' THEN 1 ELSE 0 END) AS selected " +
                     "FROM applications a JOIN drives d ON a.drive_id=d.id " +
                     "LEFT JOIN companies c ON d.company_id=c.id GROUP BY d.company_id ORDER BY selected DESC LIMIT 10";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(new Object[]{rs.getString("company"), rs.getInt("total"), rs.getInt("selected")});
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Applications by department (for admin dashboard)
    public List<Object[]> getPlacementByDepartment() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT s.department, COUNT(a.id) AS total, " +
                     "SUM(CASE WHEN a.status='selected' THEN 1 ELSE 0 END) AS selected " +
                     "FROM applications a JOIN students s ON a.student_id=s.id " +
                     "GROUP BY s.department ORDER BY selected DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(new Object[]{rs.getString("department"), rs.getInt("total"), rs.getInt("selected")});
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
