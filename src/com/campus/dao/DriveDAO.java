package com.campus.dao;

import com.campus.model.Drive;
import com.campus.model.Student;
import com.campus.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DriveDAO {

    public int create(Drive d) {
        String sql = "INSERT INTO drives (company_id,admin_id,title,description,role,salary,location,drive_type," +
                     "min_cgpa,min_tenth,min_twelfth,min_grad,eligible_batches,eligible_branches," +
                     "status,application_deadline,drive_date,created_by) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (d.getCompanyId() > 0) ps.setInt(1, d.getCompanyId()); else ps.setNull(1, Types.INTEGER);
            if (d.getAdminId() > 0) ps.setInt(2, d.getAdminId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, d.getTitle()); ps.setString(4, d.getDescription());
            ps.setString(5, d.getRole()); ps.setString(6, d.getSalary());
            ps.setString(7, d.getLocation()); ps.setString(8, d.getDriveType());
            ps.setDouble(9, d.getMinCgpa()); ps.setDouble(10, d.getMinTenth());
            ps.setDouble(11, d.getMinTwelfth()); ps.setDouble(12, d.getMinGrad());
            ps.setString(13, d.getEligibleBatches()); ps.setString(14, d.getEligibleBranches());
            ps.setString(15, d.getStatus());
            ps.setDate(16, d.getApplicationDeadline()); ps.setDate(17, d.getDriveDate());
            ps.setString(18, d.getCreatedBy());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public Drive getById(int id) {
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "(SELECT COUNT(*) FROM applications a WHERE a.drive_id=d.id) AS app_count," +
                     "(SELECT COUNT(*) FROM drive_eligible_students des WHERE des.drive_id=d.id) AS elig_count " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id WHERE d.id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Drive> getAll() {
        List<Drive> list = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "(SELECT COUNT(*) FROM applications a WHERE a.drive_id=d.id) AS app_count," +
                     "(SELECT COUNT(*) FROM drive_eligible_students des WHERE des.drive_id=d.id) AS elig_count " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id ORDER BY d.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Drive> getPublished() {
        List<Drive> list = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "(SELECT COUNT(*) FROM applications a WHERE a.drive_id=d.id) AS app_count," +
                     "(SELECT COUNT(*) FROM drive_eligible_students des WHERE des.drive_id=d.id) AS elig_count " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id " +
                     "WHERE d.status='published' ORDER BY d.application_deadline ASC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Drive> getPendingApproval() {
        List<Drive> list = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "0 AS app_count, 0 AS elig_count " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id " +
                     "WHERE d.status='pending_approval' ORDER BY d.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Drive> getByCompany(int companyId) {
        List<Drive> list = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "(SELECT COUNT(*) FROM applications a WHERE a.drive_id=d.id) AS app_count," +
                     "(SELECT COUNT(*) FROM drive_eligible_students des WHERE des.drive_id=d.id) AS elig_count " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id " +
                     "WHERE d.company_id=? ORDER BY d.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Drive> getEligibleForStudent(int studentId) {
        List<Drive> list = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name, c.industry AS company_industry," +
                     "(SELECT COUNT(*) FROM applications a WHERE a.drive_id=d.id) AS app_count," +
                     "(SELECT COUNT(*) FROM drive_eligible_students des WHERE des.drive_id=d.id) AS elig_count," +
                     "(SELECT COUNT(*) FROM applications ap WHERE ap.drive_id=d.id AND ap.student_id=?) > 0 AS is_applied," +
                     "(SELECT COUNT(*) FROM drive_eligible_students de WHERE de.drive_id=d.id AND de.student_id=?) > 0 AS is_eligible " +
                     "FROM drives d LEFT JOIN companies c ON d.company_id=c.id " +
                     "WHERE d.status='published' ORDER BY d.application_deadline ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId); ps.setInt(2, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Drive drv = map(rs);
                drv.setApplied(rs.getBoolean("is_applied"));
                drv.setEligible(rs.getBoolean("is_eligible"));
                list.add(drv);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int driveId, String status, int adminId) {
        String sql = "UPDATE drives SET status=?, approved_by=?, approved_at=NOW() WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, adminId); ps.setInt(3, driveId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Drive d) {
        String sql = "UPDATE drives SET title=?,description=?,role=?,salary=?,location=?,drive_type=?," +
                     "min_cgpa=?,min_tenth=?,min_twelfth=?,min_grad=?,eligible_batches=?,eligible_branches=?," +
                     "application_deadline=?,drive_date=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, d.getTitle()); ps.setString(2, d.getDescription());
            ps.setString(3, d.getRole()); ps.setString(4, d.getSalary());
            ps.setString(5, d.getLocation()); ps.setString(6, d.getDriveType());
            ps.setDouble(7, d.getMinCgpa()); ps.setDouble(8, d.getMinTenth());
            ps.setDouble(9, d.getMinTwelfth()); ps.setDouble(10, d.getMinGrad());
            ps.setString(11, d.getEligibleBatches()); ps.setString(12, d.getEligibleBranches());
            ps.setDate(13, d.getApplicationDeadline()); ps.setDate(14, d.getDriveDate());
            ps.setInt(15, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Mark eligible students based on criteria
    public int markEligibleStudents(int driveId, int adminId) {
        String fetchDrive = "SELECT * FROM drives WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(fetchDrive)) {
            ps.setInt(1, driveId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return 0;
            double minCgpa = rs.getDouble("min_cgpa");
            double minTenth = rs.getDouble("min_tenth");
            double minTwelfth = rs.getDouble("min_twelfth");
            double minGrad = rs.getDouble("min_grad");
            String batches = rs.getString("eligible_batches");
            String branches = rs.getString("eligible_branches");

            // Delete previous eligible entries
            PreparedStatement del = c.prepareStatement("DELETE FROM drive_eligible_students WHERE drive_id=?");
            del.setInt(1, driveId); del.executeUpdate(); del.close();

            // Build query
            StringBuilder q = new StringBuilder("SELECT id FROM students WHERE is_active=1 AND cgpa>=? AND tenth_percent>=? AND twelfth_percent>=? AND grad_percent>=?");
            if (batches != null && !batches.isEmpty()) {
                String[] bArr = batches.split(",");
                q.append(" AND batch IN (");
                for (int i=0; i<bArr.length; i++) { q.append("?"); if(i<bArr.length-1) q.append(","); }
                q.append(")");
            }

            PreparedStatement sel = c.prepareStatement(q.toString());
            sel.setDouble(1, minCgpa); sel.setDouble(2, minTenth);
            sel.setDouble(3, minTwelfth); sel.setDouble(4, minGrad);
            if (batches != null && !batches.isEmpty()) {
                String[] bArr = batches.split(",");
                for (int i=0; i<bArr.length; i++) sel.setString(5+i, bArr[i].trim());
            }

            ResultSet srs = sel.executeQuery();
            int count = 0;
            PreparedStatement ins = c.prepareStatement("INSERT IGNORE INTO drive_eligible_students (drive_id,student_id,marked_by) VALUES (?,?,?)");
            while (srs.next()) {
                int sid = srs.getInt("id");
                // Branch filter
                if (branches != null && !branches.isEmpty()) {
                    // Check if student matches — need to fetch department
                    PreparedStatement bp = c.prepareStatement("SELECT department FROM students WHERE id=?");
                    bp.setInt(1, sid);
                    ResultSet br = bp.executeQuery();
                    if (br.next()) {
                        String dept = br.getString("department");
                        boolean match = false;
                        for (String b : branches.split(",")) { if (b.trim().equalsIgnoreCase(dept)) { match=true; break; } }
                        bp.close();
                        if (!match) continue;
                    }
                }
                ins.setInt(1, driveId); ins.setInt(2, sid); ins.setInt(3, adminId);
                ins.addBatch(); count++;
            }
            ins.executeBatch(); ins.close(); sel.close();
            return count;
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public boolean addEligibleStudent(int driveId, int studentId, int adminId) {
        String sql = "INSERT IGNORE INTO drive_eligible_students (drive_id,student_id,marked_by) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId); ps.setInt(2, studentId); ps.setInt(3, adminId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean removeEligibleStudent(int driveId, int studentId) {
        String sql = "DELETE FROM drive_eligible_students WHERE drive_id=? AND student_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, driveId); ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int getTotalCount() {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM drives")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getActiveCount() {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM drives WHERE status='published'")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Drive map(ResultSet rs) throws SQLException {
        Drive d = new Drive();
        d.setId(rs.getInt("id"));
        try { d.setCompanyId(rs.getInt("company_id")); } catch(Exception ignored){}
        try { d.setAdminId(rs.getInt("admin_id")); } catch(Exception ignored){}
        d.setTitle(rs.getString("title"));
        d.setDescription(rs.getString("description"));
        d.setRole(rs.getString("role"));
        d.setSalary(rs.getString("salary"));
        d.setLocation(rs.getString("location"));
        d.setDriveType(rs.getString("drive_type"));
        d.setMinCgpa(rs.getDouble("min_cgpa"));
        d.setMinTenth(rs.getDouble("min_tenth"));
        d.setMinTwelfth(rs.getDouble("min_twelfth"));
        d.setMinGrad(rs.getDouble("min_grad"));
        d.setEligibleBatches(rs.getString("eligible_batches"));
        d.setEligibleBranches(rs.getString("eligible_branches"));
        d.setStatus(rs.getString("status"));
        d.setApplicationDeadline(rs.getDate("application_deadline"));
        d.setDriveDate(rs.getDate("drive_date"));
        d.setCreatedBy(rs.getString("created_by"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        try { d.setCompanyName(rs.getString("company_name")); } catch(Exception ignored){}
        try { d.setCompanyIndustry(rs.getString("company_industry")); } catch(Exception ignored){}
        try { d.setApplicationCount(rs.getInt("app_count")); } catch(Exception ignored){}
        try { d.setEligibleCount(rs.getInt("elig_count")); } catch(Exception ignored){}
        return d;
    }
}
