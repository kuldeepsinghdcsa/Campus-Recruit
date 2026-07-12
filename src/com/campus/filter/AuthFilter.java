package com.campus.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/company/*", "/student/*"})
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);

        boolean loggedIn = false;

        if (path.startsWith("/admin/")) {
            loggedIn = (session != null && session.getAttribute("adminId") != null);
            if (!loggedIn) { response.sendRedirect(request.getContextPath() + "/login.jsp?role=admin"); return; }
        } else if (path.startsWith("/company/")) {
            loggedIn = (session != null && session.getAttribute("companyId") != null);
            if (!loggedIn) { response.sendRedirect(request.getContextPath() + "/login.jsp?role=company"); return; }
        } else if (path.startsWith("/student/")) {
            loggedIn = (session != null && session.getAttribute("studentId") != null);
            if (!loggedIn) { response.sendRedirect(request.getContextPath() + "/login.jsp?role=student"); return; }
        }

        chain.doFilter(req, res);
    }

    public void init(FilterConfig fc) {}
    public void destroy() {}
}
