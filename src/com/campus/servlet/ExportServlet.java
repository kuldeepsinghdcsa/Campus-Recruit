package com.campus.servlet;

import com.campus.dao.ApplicationDAO;
import com.campus.model.Application;
import com.campus.util.ExcelExportUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/export-students", "/company/export-students"})
public class ExportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        boolean isAdmin   = req.getSession().getAttribute("adminId")   != null;
        boolean isCompany = req.getSession().getAttribute("companyId") != null;

        if (!isAdmin && !isCompany) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String driveIdStr = req.getParameter("driveId");
        if (driveIdStr == null) { res.sendError(400, "Missing driveId"); return; }
        int driveId = Integer.parseInt(driveIdStr);

        String[] fields = req.getParameterValues("fields");
        if (fields == null || fields.length == 0) {
            fields = new String[]{"name","email","phone","department","batch","cgpa","status"};
        }

        List<Application> apps = new ApplicationDAO().getByDrive(driveId);
        String title = "Drive #" + driveId + " Applicants";

        try {
            byte[] excel = ExcelExportUtil.exportApplications(apps, fields, title);
            res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            res.setHeader("Content-Disposition", "attachment; filename=\"applicants_drive_" + driveId + ".xlsx\"");
            res.getOutputStream().write(excel);
        } catch (Exception e) {
            res.sendError(500, "Export failed: " + e.getMessage());
        }
    }
}
