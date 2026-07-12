package com.campus.dao;

import com.campus.model.Admin;
import com.campus.util.DBConnection;
import java.sql.*;

public class AdminDAO {

    public Admin login(String email, String password) {
        String sql = "SELECT * FROM admins WHERE email=? AND password=MD5(?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Admin getById(int id) {
        String sql = "SELECT * FROM admins WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean update(Admin a) {
        String sql = "UPDATE admins SET name=?,department=?,university=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getName()); ps.setString(2, a.getDepartment());
            ps.setString(3, a.getUniversity()); ps.setInt(4, a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Admin map(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setEmail(rs.getString("email"));
        a.setPassword(rs.getString("password"));
        a.setDepartment(rs.getString("department"));
        a.setUniversity(rs.getString("university"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
