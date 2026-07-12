package com.campus.servlet;

import com.campus.dao.*;
import com.campus.model.*;
import com.campus.util.ExcelExportUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/company/action/*")
public class CompanyServlet extends HttpServlet {

    private final DriveDAO driveDAO         = new DriveDAO();
    private final ApplicationDAO appDAO     = new ApplicationDAO();
    private final CompanyDAO companyDAO     = new CompanyDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null) action = "/dashboard";
        int companyId = (int) req.getSession().getAttribute("companyId");

        switch (action) {
            case "/drives":
                req.setAttribute("drives", driveDAO.getByCompany(companyId));
                req.getRequestDispatcher("/company/drives.jsp").forward(req, res);
                break;
            case "/create-drive":
                req.getRequestDispatcher("/company/create-drive.jsp").forward(req, res);
                break;
            case "/applied-students":
                int did = Integer.parseInt(req.getParameter("driveId"));
                Drive drv = driveDAO.getById(did);
                if (drv == null || drv.getCompanyId() != companyId) {
                    res.sendRedirect(req.getContextPath() + "/company/action/drives");
                    return;
                }
                List<Application> apps = appDAO.getByDrive(did);
                req.setAttribute("drive", drv);
                req.setAttribute("applications", apps);
                req.getRequestDispatcher("/company/applied-students.jsp").forward(req, res);
                break;
            case "/export-students":
                handleExport(req, res, companyId);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/company/dashboard.jsp");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null) action = "";
        int companyId = (int) req.getSession().getAttribute("companyId");

        switch (action) {
            case "/create-drive": {
                Drive d = new Drive();
                d.setCompanyId(companyId);
                d.setTitle(req.getParameter("title"));
                d.setDescription(req.getParameter("description"));
                d.setRole(req.getParameter("role"));
                d.setSalary(req.getParameter("salary"));
                d.setLocation(req.getParameter("location"));
                d.setDriveType(req.getParameter("driveType"));
                d.setMinCgpa(parseDouble(req.getParameter("minCgpa")));
                d.setMinTenth(parseDouble(req.getParameter("minTenth")));
                d.setMinTwelfth(parseDouble(req.getParameter("minTwelfth")));
                d.setMinGrad(parseDouble(req.getParameter("minGrad")));
                d.setEligibleBatches(req.getParameter("eligibleBatches"));
                d.setEligibleBranches(req.getParameter("eligibleBranches"));
                d.setApplicationDeadline(java.sql.Date.valueOf(req.getParameter("deadline")));
                if (req.getParameter("driveDate") != null && !req.getParameter("driveDate").isEmpty())
                    d.setDriveDate(java.sql.Date.valueOf(req.getParameter("driveDate")));
                d.setStatus("pending_approval");
                d.setCreatedBy("company");
                int newId = driveDAO.create(d);
                if (newId > 0) {
                    req.getSession().setAttribute("success", "Drive request sent to admin for approval!");
                } else {
                    req.getSession().setAttribute("error", "Failed to create drive request.");
                }
                res.sendRedirect(req.getContextPath() + "/company/action/drives");
                break;
            }
            default:
                res.sendRedirect(req.getContextPath() + "/company/dashboard.jsp");
        }
    }

    private void handleExport(HttpServletRequest req, HttpServletResponse res, int companyId) throws IOException {
        int driveId = Integer.parseInt(req.getParameter("driveId"));
        Drive drv = driveDAO.getById(driveId);
        if (drv == null || drv.getCompanyId() != companyId) {
            res.sendRedirect(req.getContextPath() + "/company/action/drives"); return;
        }
        String[] fields = req.getParameterValues("fields");
        if (fields == null) fields = new String[]{"name","email","phone","department","batch","cgpa"};
        List<Application> apps = appDAO.getByDrive(driveId);
        try {
            byte[] excel = ExcelExportUtil.exportApplications(apps, fields, drv.getTitle());
            res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            res.setHeader("Content-Disposition", "attachment; filename=\"applicants_" + driveId + ".xlsx\"");
            res.getOutputStream().write(excel);
        } catch (Exception e) {
            res.sendError(500, "Export failed: " + e.getMessage());
        }
    }

    private double parseDouble(String val) {
        try { return Double.parseDouble(val); } catch (Exception e) { return 0.0; }
    }
}
