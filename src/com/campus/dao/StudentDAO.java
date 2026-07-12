package com.campus.dao;

import com.campus.model.Student;
import com.campus.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student login(String email, String password) {
        String sql = "SELECT * FROM students WHERE email=? AND password=MD5(?) AND is_active=1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(Student s) {
        String sql = "INSERT INTO students (name,email,password,phone,department,batch,roll_number) VALUES (?,?,MD5(?),?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getEmail());
            ps.setString(3, s.getPassword()); ps.setString(4, s.getPhone());
            ps.setString(5, s.getDepartment()); ps.setString(6, s.getBatch());
            ps.setString(7, s.getRollNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean emailExists(String email) {
        String sql = "SELECT id FROM students WHERE email=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Student getById(int id) {
        String sql = "SELECT * FROM students WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Student> getAll() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Student> getByDepartment(String department) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE department=? ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, department);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateProfile(Student s) {
        String sql = "UPDATE students SET name=?,phone=?,dob=?,gender=?,address=?,department=?,batch=?," +
                     "roll_number=?,cgpa=?,tenth_percent=?,twelfth_percent=?,grad_percent=?,masters_percent=?,skills=?,profile_complete=1 WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getPhone());
            ps.setDate(3, s.getDob()); ps.setString(4, s.getGender());
            ps.setString(5, s.getAddress()); ps.setString(6, s.getDepartment());
            ps.setString(7, s.getBatch()); ps.setString(8, s.getRollNumber());
            ps.setDouble(9, s.getCgpa()); ps.setDouble(10, s.getTenthPercent());
            ps.setDouble(11, s.getTwelfthPercent()); ps.setDouble(12, s.getGradPercent());
            ps.setDouble(13, s.getMastersPercent()); ps.setString(14, s.getSkills());
            ps.setInt(15, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateResume(int studentId, String resumePath) {
        String sql = "UPDATE students SET resume_path=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, resumePath); ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateByAdmin(Student s) {
        String sql = "UPDATE students SET name=?,phone=?,department=?,batch=?,roll_number=?,cgpa=?," +
                     "tenth_percent=?,twelfth_percent=?,grad_percent=?,masters_percent=?,is_active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getPhone());
            ps.setString(3, s.getDepartment()); ps.setString(4, s.getBatch());
            ps.setString(5, s.getRollNumber()); ps.setDouble(6, s.getCgpa());
            ps.setDouble(7, s.getTenthPercent()); ps.setDouble(8, s.getTwelfthPercent());
            ps.setDouble(9, s.getGradPercent()); ps.setDouble(10, s.getMastersPercent());
            ps.setBoolean(11, s.isActive()); ps.setInt(12, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Student> getEligibleStudents(int driveId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.* FROM students s JOIN drive_eligible_students des ON s.id=des.student_id WHERE des.drive_id=? ORDER BY s.name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Stats
    public int getTotalCount() {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM students")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getPlacedCount() {
        String sql = "SELECT COUNT(DISTINCT student_id) FROM applications WHERE status='selected'";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Student map(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setPhone(rs.getString("phone"));
        s.setDob(rs.getDate("dob"));
        s.setGender(rs.getString("gender"));
        s.setAddress(rs.getString("address"));
        s.setDepartment(rs.getString("department"));
        s.setBatch(rs.getString("batch"));
        s.setRollNumber(rs.getString("roll_number"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setTenthPercent(rs.getDouble("tenth_percent"));
        s.setTwelfthPercent(rs.getDouble("twelfth_percent"));
        s.setGradPercent(rs.getDouble("grad_percent"));
        s.setMastersPercent(rs.getDouble("masters_percent"));
        s.setSkills(rs.getString("skills"));
        s.setResumePath(rs.getString("resume_path"));
        s.setProfileComplete(rs.getBoolean("profile_complete"));
        s.setActive(rs.getBoolean("is_active"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
