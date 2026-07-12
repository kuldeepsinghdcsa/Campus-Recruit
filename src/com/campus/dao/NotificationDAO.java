package com.campus.dao;

import com.campus.util.DBConnection;
import java.sql.*;
import java.util.*;

public class NotificationDAO {

    public boolean createNotification(int studentId, int driveId, String title, String message, String type) {
        String sql = "INSERT INTO notifications (student_id,drive_id,title,message,type) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            if (driveId > 0) ps.setInt(2, driveId); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, title); ps.setString(4, message); ps.setString(5, type);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public void createDriveNotificationsForEligible(int driveId, String driveTitle, String role) {
        String sql = "SELECT s.id FROM students s JOIN drive_eligible_students des ON s.id=des.student_id WHERE des.drive_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId);
            ResultSet rs = ps.executeQuery();
            PreparedStatement ins = c.prepareStatement(
                "INSERT IGNORE INTO notifications (student_id,drive_id,title,message,type) VALUES (?,?,?,?,?)");
            while (rs.next()) {
                int sid = rs.getInt("id");
                ins.setInt(1, sid); ins.setInt(2, driveId);
                ins.setString(3, "New Drive: " + driveTitle);
                ins.setString(4, "You are eligible for '" + driveTitle + "' - " + role + ". Apply before the deadline!");
                ins.setString(5, "drive");
                ins.addBatch();
            }
            ins.executeBatch(); ins.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<Map<String,Object>> getByStudent(int studentId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE student_id=? ORDER BY created_at DESC LIMIT 50";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> n = new LinkedHashMap<>();
                n.put("id", rs.getInt("id"));
                n.put("driveId", rs.getInt("drive_id"));
                n.put("title", rs.getString("title"));
                n.put("message", rs.getString("message"));
                n.put("isRead", rs.getBoolean("is_read"));
                n.put("type", rs.getString("type"));
                n.put("createdAt", rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int studentId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE student_id=? AND is_read=0";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean markAllRead(int studentId) {
        String sql = "UPDATE notifications SET is_read=1 WHERE student_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
