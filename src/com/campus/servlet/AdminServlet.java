package com.campus.servlet;

import com.campus.dao.*;
import com.campus.model.*;
import com.campus.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/action/*")
public class AdminServlet extends HttpServlet {

    private final AdminDAO adminDAO           = new AdminDAO();
    private final StudentDAO studentDAO       = new StudentDAO();
    private final DriveDAO driveDAO           = new DriveDAO();
    private final ApplicationDAO appDAO       = new ApplicationDAO();
    private final CompanyDAO companyDAO       = new CompanyDAO();
    private final NotificationDAO notifDAO    = new NotificationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/students":
                req.setAttribute("students", studentDAO.getAll());
                req.getRequestDispatcher("/admin/students.jsp").forward(req, res);
                break;
            case "/student-detail":
                int sid = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("student", studentDAO.getById(sid));
                req.getRequestDispatcher("/admin/student-detail.jsp").forward(req, res);
                break;
            case "/drives":
                req.setAttribute("drives", driveDAO.getAll());
                req.getRequestDispatcher("/admin/drives.jsp").forward(req, res);
                break;
            case "/drive-detail":
                int did = Integer.parseInt(req.getParameter("id"));
                Drive drv = driveDAO.getById(did);
                List<Application> apps = appDAO.getByDrive(did);
                List<Student> eligible = studentDAO.getEligibleStudents(did);
                req.setAttribute("drive", drv);
                req.setAttribute("applications", apps);
                req.setAttribute("eligibleStudents", eligible);
                req.getRequestDispatcher("/admin/drive-detail.jsp").forward(req, res);
                break;
            case "/create-drive":
                req.setAttribute("companies", companyDAO.getApproved());
                req.getRequestDispatcher("/admin/create-drive.jsp").forward(req, res);
                break;
            case "/companies":
                req.setAttribute("companies", companyDAO.getAll());
                req.setAttribute("pendingCompanies", companyDAO.getPending());
                req.getRequestDispatcher("/admin/companies.jsp").forward(req, res);
                break;
            case "/pending-drives":
                req.setAttribute("pendingDrives", driveDAO.getPendingApproval());
                req.getRequestDispatcher("/admin/pending-drives.jsp").forward(req, res);
                break;
            case "/applications":
                int driveIdParam = -1;
                if (req.getParameter("driveId") != null) driveIdParam = Integer.parseInt(req.getParameter("driveId"));
                if (driveIdParam > 0) {
                    req.setAttribute("applications", appDAO.getByDrive(driveIdParam));
                    req.setAttribute("drive", driveDAO.getById(driveIdParam));
                }
                req.getRequestDispatcher("/admin/applications.jsp").forward(req, res);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null) action = "";
        int adminId = (int) req.getSession().getAttribute("adminId");

        switch (action) {
            case "/create-drive": {
                Drive d = new Drive();
                d.setTitle(req.getParameter("title"));
                d.setDescription(req.getParameter("description"));
                d.setRole(req.getParameter("role"));
                d.setSalary(req.getParameter("salary"));
                d.setLocation(req.getParameter("location"));
                d.setDriveType(req.getParameter("driveType"));
                String cIdStr = req.getParameter("companyId");
                if (cIdStr != null && !cIdStr.isEmpty()) d.setCompanyId(Integer.parseInt(cIdStr));
                d.setAdminId(adminId);
                d.setMinCgpa(parseDouble(req.getParameter("minCgpa")));
                d.setMinTenth(parseDouble(req.getParameter("minTenth")));
                d.setMinTwelfth(parseDouble(req.getParameter("minTwelfth")));
                d.setMinGrad(parseDouble(req.getParameter("minGrad")));
                d.setEligibleBatches(req.getParameter("eligibleBatches"));
                d.setEligibleBranches(req.getParameter("eligibleBranches"));
                d.setApplicationDeadline(java.sql.Date.valueOf(req.getParameter("deadline")));
                if (req.getParameter("driveDate") != null && !req.getParameter("driveDate").isEmpty())
                    d.setDriveDate(java.sql.Date.valueOf(req.getParameter("driveDate")));
                d.setStatus(req.getParameter("publish") != null ? "published" : "draft");
                d.setCreatedBy("admin");
                int newId = driveDAO.create(d);
                if (newId > 0) {
                    driveDAO.markEligibleStudents(newId, adminId);
                    if ("published".equals(d.getStatus())) {
                        notifDAO.createDriveNotificationsForEligible(newId, d.getTitle(), d.getRole());
                        sendDriveEmails(newId, d.getTitle(), d.getRole(), d.getSalary(),
                                        d.getApplicationDeadline().toString(), req);
                    }
                    req.getSession().setAttribute("success", "Drive created successfully!");
                } else {
                    req.getSession().setAttribute("error", "Failed to create drive.");
                }
                res.sendRedirect(req.getContextPath() + "/admin/action/drives");
                break;
            }
            case "/approve-company": {
                int coId = Integer.parseInt(req.getParameter("companyId"));
                String st  = req.getParameter("status");
                companyDAO.updateStatus(coId, st);
                req.getSession().setAttribute("success", "Company status updated.");
                res.sendRedirect(req.getContextPath() + "/admin/action/companies");
                break;
            }
            case "/approve-drive": {
                int dId    = Integer.parseInt(req.getParameter("driveId"));
                String st2 = req.getParameter("status");
                driveDAO.updateStatus(dId, st2, adminId);
                if ("published".equals(st2)) {
                    Drive drive = driveDAO.getById(dId);
                    driveDAO.markEligibleStudents(dId, adminId);
                    notifDAO.createDriveNotificationsForEligible(dId, drive.getTitle(), drive.getRole());
                    sendDriveEmails(dId, drive.getTitle(), drive.getRole(), drive.getSalary(),
                                    drive.getApplicationDeadline().toString(), req);
                }
                req.getSession().setAttribute("success", "Drive status updated.");
                res.sendRedirect(req.getContextPath() + "/admin/action/pending-drives");
                break;
            }
            case "/update-student": {
                Student s = studentDAO.getById(Integer.parseInt(req.getParameter("studentId")));
                s.setName(req.getParameter("name"));
                s.setPhone(req.getParameter("phone"));
                s.setDepartment(req.getParameter("department"));
                s.setBatch(req.getParameter("batch"));
                s.setRollNumber(req.getParameter("rollNumber"));
                s.setCgpa(parseDouble(req.getParameter("cgpa")));
                s.setTenthPercent(parseDouble(req.getParameter("tenthPercent")));
                s.setTwelfthPercent(parseDouble(req.getParameter("twelfthPercent")));
                s.setGradPercent(parseDouble(req.getParameter("gradPercent")));
                s.setMastersPercent(parseDouble(req.getParameter("mastersPercent")));
                s.setActive("on".equals(req.getParameter("isActive")));
                studentDAO.updateByAdmin(s);
                req.getSession().setAttribute("success", "Student updated.");
                res.sendRedirect(req.getContextPath() + "/admin/action/student-detail?id=" + s.getId());
                break;
            }
            case "/update-application-status": {
                int appId = Integer.parseInt(req.getParameter("applicationId"));
                String newStatus = req.getParameter("status");
                appDAO.updateStatus(appId, newStatus);
                res.sendRedirect(req.getHeader("Referer"));
                break;
            }
            case "/mark-eligible": {
                int dId2 = Integer.parseInt(req.getParameter("driveId"));
                int count = driveDAO.markEligibleStudents(dId2, adminId);
                req.getSession().setAttribute("success", count + " students marked as eligible.");
                res.sendRedirect(req.getContextPath() + "/admin/action/drive-detail?id=" + dId2);
                break;
            }
            case "/publish-drive": {
                int dId3 = Integer.parseInt(req.getParameter("driveId"));
                driveDAO.updateStatus(dId3, "published", adminId);
                Drive drive3 = driveDAO.getById(dId3);
                driveDAO.markEligibleStudents(dId3, adminId);
                notifDAO.createDriveNotificationsForEligible(dId3, drive3.getTitle(), drive3.getRole());
                sendDriveEmails(dId3, drive3.getTitle(), drive3.getRole(), drive3.getSalary(),
                                drive3.getApplicationDeadline() != null ? drive3.getApplicationDeadline().toString() : "N/A", req);
                req.getSession().setAttribute("success", "Drive published. Eligible students notified.");
                res.sendRedirect(req.getContextPath() + "/admin/action/drive-detail?id=" + dId3);
                break;
            }
            default:
                res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        }
    }

    private void sendDriveEmails(int driveId, String title, String role, String salary,
                                  String deadline, HttpServletRequest req) {
        List<Student> students = new StudentDAO().getEligibleStudents(driveId);
        String appUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                      + req.getContextPath() + "/student/dashboard.jsp";
        CompanyDAO cDao = new CompanyDAO();
        Drive drv = driveDAO.getById(driveId);
        String companyName = drv != null && drv.getCompanyId() > 0
            ? cDao.getById(drv.getCompanyId()).getName() : "University";
        new Thread(() -> {
            for (Student s : students) {
                String html = EmailUtil.buildDriveNotificationEmail(s.getName(), title, companyName, role, salary, deadline, appUrl);
                EmailUtil.sendEmail(s.getEmail(), "New Placement Drive: " + title, html);
            }
        }).start();
    }

    private double parseDouble(String val) {
        try { return Double.parseDouble(val); } catch (Exception e) { return 0.0; }
    }
}
