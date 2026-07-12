package com.campus.servlet;

import com.campus.dao.*;
import com.campus.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String role     = req.getParameter("role");
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password");
        HttpSession session = req.getSession();

        if ("admin".equals(role)) {
            Admin admin = new AdminDAO().login(email, password);
            if (admin != null) {
                session.setAttribute("adminId",   admin.getId());
                session.setAttribute("adminName", admin.getName());
                session.setAttribute("adminObj",  admin);
                res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
            } else {
                req.getSession().setAttribute("loginError", "Invalid admin credentials.");
                res.sendRedirect(req.getContextPath() + "/login.jsp?role=admin");
            }

        } else if ("company".equals(role)) {
            Company co = new CompanyDAO().login(email, password);
            if (co != null) {
                session.setAttribute("companyId",   co.getId());
                session.setAttribute("companyName", co.getName());
                session.setAttribute("companyObj",  co);
                res.sendRedirect(req.getContextPath() + "/company/dashboard.jsp");
            } else {
                req.getSession().setAttribute("loginError", "Invalid company credentials or account not approved.");
                res.sendRedirect(req.getContextPath() + "/login.jsp?role=company");
            }

        } else if ("student".equals(role)) {
            Student st = new StudentDAO().login(email, password);
            if (st != null) {
                session.setAttribute("studentId",   st.getId());
                session.setAttribute("studentName", st.getName());
                session.setAttribute("studentObj",  st);
                res.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");
            } else {
                req.getSession().setAttribute("loginError", "Invalid student credentials.");
                res.sendRedirect(req.getContextPath() + "/login.jsp?role=student");
            }
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
