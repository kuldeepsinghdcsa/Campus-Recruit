package com.campus.servlet;

import com.campus.dao.*;
import com.campus.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String role = req.getParameter("role");
        HttpSession session = req.getSession();

        if ("student".equals(role)) {
            StudentDAO dao = new StudentDAO();
            String email = req.getParameter("email").trim();
            if (dao.emailExists(email)) {
                session.setAttribute("registerError", "Email already registered.");
                res.sendRedirect(req.getContextPath() + "/register.jsp?role=student");
                return;
            }
            Student s = new Student();
            s.setName(req.getParameter("name").trim());
            s.setEmail(email);
            s.setPassword(req.getParameter("password"));
            s.setPhone(req.getParameter("phone"));
            s.setDepartment(req.getParameter("department"));
            s.setBatch(req.getParameter("batch"));
            s.setRollNumber(req.getParameter("rollNumber"));

            if (dao.register(s)) {
                session.setAttribute("registerSuccess", "Registration successful! Please login.");
                res.sendRedirect(req.getContextPath() + "/login.jsp?role=student");
            } else {
                session.setAttribute("registerError", "Registration failed. Try again.");
                res.sendRedirect(req.getContextPath() + "/register.jsp?role=student");
            }

        } else if ("company".equals(role)) {
            CompanyDAO dao = new CompanyDAO();
            String email = req.getParameter("email").trim();
            if (dao.emailExists(email)) {
                session.setAttribute("registerError", "Email already registered.");
                res.sendRedirect(req.getContextPath() + "/register.jsp?role=company");
                return;
            }
            Company co = new Company();
            co.setName(req.getParameter("name").trim());
            co.setEmail(email);
            co.setPassword(req.getParameter("password"));
            co.setIndustry(req.getParameter("industry"));
            co.setDescription(req.getParameter("description"));
            co.setWebsite(req.getParameter("website"));
            co.setContactPerson(req.getParameter("contactPerson"));
            co.setContactPhone(req.getParameter("contactPhone"));

            if (dao.register(co)) {
                session.setAttribute("registerSuccess", "Company registered! Awaiting admin approval.");
                res.sendRedirect(req.getContextPath() + "/login.jsp?role=company");
            } else {
                session.setAttribute("registerError", "Registration failed. Try again.");
                res.sendRedirect(req.getContextPath() + "/register.jsp?role=company");
            }
        } else {
            res.sendRedirect(req.getContextPath() + "/register.jsp");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/register.jsp");
    }
}
