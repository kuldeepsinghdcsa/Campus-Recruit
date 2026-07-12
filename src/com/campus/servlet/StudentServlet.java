package com.campus.servlet;

import com.campus.dao.ApplicationDAO;
import com.campus.dao.DriveDAO;
import com.campus.dao.NotificationDAO;
import com.campus.dao.StudentDAO;
import com.campus.model.Drive;
import com.campus.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/student/action/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class StudentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final StudentDAO studentDAO = new StudentDAO();
    private final DriveDAO driveDAO = new DriveDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        String action = req.getPathInfo();
        if (action == null)
            action = "/dashboard";

        switch (action) {

        case "/drives":
            req.setAttribute("drives", driveDAO.getEligibleForStudent(studentId));
            req.getRequestDispatcher("/student/drives.jsp").forward(req, res);
            break;

        case "/applications":
            req.setAttribute("applications", appDAO.getByStudent(studentId));
            req.getRequestDispatcher("/student/applications.jsp").forward(req, res);
            break;

        case "/profile":
            req.setAttribute("student", studentDAO.getById(studentId));
            req.getRequestDispatcher("/student/profile.jsp").forward(req, res);
            break;

        case "/notifications":
            notifDAO.markAllRead(studentId);
            req.setAttribute("notifications", notifDAO.getByStudent(studentId));
            req.getRequestDispatcher("/student/notifications.jsp").forward(req, res);
            break;

        case "/drive-detail":

            int driveId = Integer.parseInt(req.getParameter("id"));

            Drive drive = driveDAO.getById(driveId);

            boolean applied = appDAO.hasApplied(driveId, studentId);

            req.setAttribute("drive", drive);
            req.setAttribute("applied", applied);

            req.getRequestDispatcher("/student/drive-detail.jsp").forward(req, res);

            break;

        default:

            res.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        String action = req.getPathInfo();

        if (action == null)
            action = "";

        switch (action) {

        case "/apply":

            int driveId = Integer.parseInt(req.getParameter("driveId"));

            String coverLetter = req.getParameter("coverLetter");

            if (appDAO.apply(driveId, studentId, coverLetter)) {

                session.setAttribute("success", "Application submitted successfully.");

            } else {

                session.setAttribute("error", "You have already applied for this drive.");

            }

            res.sendRedirect(req.getContextPath() + "/student/action/drives");

            break;

        case "/update-profile":

            Student student = studentDAO.getById(studentId);

            student.setName(req.getParameter("name"));
            student.setPhone(req.getParameter("phone"));

            String dob = req.getParameter("dob");

            if (dob != null && !dob.isEmpty()) {

                student.setDob(java.sql.Date.valueOf(dob));

            }

            student.setGender(req.getParameter("gender"));
            student.setAddress(req.getParameter("address"));
            student.setDepartment(req.getParameter("department"));
            student.setBatch(req.getParameter("batch"));
            student.setRollNumber(req.getParameter("rollNumber"));

            student.setCgpa(parseDouble(req.getParameter("cgpa")));
            student.setTenthPercent(parseDouble(req.getParameter("tenthPercent")));
            student.setTwelfthPercent(parseDouble(req.getParameter("twelfthPercent")));
            student.setGradPercent(parseDouble(req.getParameter("gradPercent")));
            student.setMastersPercent(parseDouble(req.getParameter("mastersPercent")));

            student.setSkills(req.getParameter("skills"));

            if (studentDAO.updateProfile(student)) {

                session.setAttribute("studentName", student.getName());
                session.setAttribute("studentObj", studentDAO.getById(studentId));
                session.setAttribute("success", "Profile updated successfully.");

            } else {

                session.setAttribute("error", "Failed to update profile.");

            }

            res.sendRedirect(req.getContextPath() + "/student/action/profile");

            break;

        case "/upload-resume":

            try {

                Part filePart = req.getPart("resume");

                if (filePart == null || filePart.getSize() == 0) {

                    session.setAttribute("error", "Please select a resume.");

                    res.sendRedirect(req.getContextPath() + "/student/action/profile");

                    return;

                }

                String uploadPath = getServletContext().getRealPath("/uploads/resumes");

                File folder = new File(uploadPath);

                if (!folder.exists()) {

                    folder.mkdirs();

                }

                String originalFileName = new File(filePart.getSubmittedFileName()).getName();

                String fileName = studentId + "_" + System.currentTimeMillis() + "_" + originalFileName;

                filePart.write(uploadPath + File.separator + fileName);

                studentDAO.updateResume(studentId, "uploads/resumes/" + fileName);

                session.setAttribute("studentObj", studentDAO.getById(studentId));

                session.setAttribute("success", "Resume uploaded successfully.");

            } catch (Exception e) {

                e.printStackTrace();

                session.setAttribute("error", "Resume upload failed.");

            }

            res.sendRedirect(req.getContextPath() + "/student/action/profile");

            break;

        default:

            res.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");

        }

    }

    private double parseDouble(String value) {

        try {

            return Double.parseDouble(value);

        } catch (Exception e) {

            return 0.0;

        }

    }

}