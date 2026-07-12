package com.campus.dao;

import com.campus.model.Company;
import com.campus.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public Company login(String email, String password) {
        String sql = "SELECT * FROM companies WHERE email=? AND password=MD5(?) AND status='approved'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(Company co) {
        String sql = "INSERT INTO companies (name,email,password,industry,description,website,contact_person,contact_phone) VALUES (?,?,MD5(?),?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, co.getName()); ps.setString(2, co.getEmail());
            ps.setString(3, co.getPassword()); ps.setString(4, co.getIndustry());
            ps.setString(5, co.getDescription()); ps.setString(6, co.getWebsite());
            ps.setString(7, co.getContactPerson()); ps.setString(8, co.getContactPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean emailExists(String email) {
        String sql = "SELECT id FROM companies WHERE email=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Company getById(int id) {
        String sql = "SELECT * FROM companies WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Company> getAll() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Company> getApproved() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies WHERE status='approved' ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Company> getPending() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies WHERE status='pending' ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE companies SET status=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int getTotalCount() {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM companies WHERE status='approved'")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Company map(ResultSet rs) throws SQLException {
        Company co = new Company();
        co.setId(rs.getInt("id"));
        co.setName(rs.getString("name"));
        co.setEmail(rs.getString("email"));
        co.setPassword(rs.getString("password"));
        co.setIndustry(rs.getString("industry"));
        co.setDescription(rs.getString("description"));
        co.setWebsite(rs.getString("website"));
        co.setContactPerson(rs.getString("contact_person"));
        co.setContactPhone(rs.getString("contact_phone"));
        co.setStatus(rs.getString("status"));
        co.setCreatedAt(rs.getTimestamp("created_at"));
        return co;
    }
}
