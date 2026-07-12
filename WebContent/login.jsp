<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String role = request.getParameter("role");
    if (role == null) role = "student";
    String error = (String) session.getAttribute("loginError");
    String success = (String) session.getAttribute("registerSuccess");
    session.removeAttribute("loginError");
    session.removeAttribute("registerSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login - Campus Recruitment</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div style="text-align:center;margin-bottom:20px;">
      <a href="${pageContext.request.contextPath}/index.jsp" style="color:rgba(255,255,255,.7);font-size:14px;">← Back to Home</a>
    </div>
    <div class="auth-card">
      <div class="auth-header">
        <div class="logo">
          <% if("admin".equals(role)){ %>⚙️<% } else if("company".equals(role)){ %>🏢<% } else { %>🎓<% } %>
        </div>
        <h2>Welcome Back</h2>
        <p>Sign in to your <%= "admin".equals(role)?"Admin":("company".equals(role)?"Company":"Student") %> account</p>
      </div>

      <!-- Role Tabs -->
      <div class="auth-tabs">
        <a href="?role=student" class="tab <%= "student".equals(role)?"active":"" %>">Student</a>
        <a href="?role=company" class="tab <%= "company".equals(role)?"active":"" %>">Company</a>
        <a href="?role=admin"   class="tab <%= "admin".equals(role)?"active":"" %>">Admin</a>
      </div>

      <% if(error != null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>
      <% if(success != null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>

      <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <input type="hidden" name="role" value="<%= role %>">
        <div class="form-group">
          <label>Email Address</label>
          <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">
          Sign In as <%= "admin".equals(role)?"Admin":("company".equals(role)?"Company":"Student") %>
        </button>
      </form>

      <% if(!"admin".equals(role)){ %>
      <p style="text-align:center;margin-top:18px;font-size:14px;color:#888;">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register.jsp?role=<%= role %>">Register here</a>
      </p>
      <% } %>

      <% if("admin".equals(role)){ %>
      <div style="margin-top:16px;padding:12px;background:#f5f5f5;border-radius:8px;font-size:12px;color:#888;text-align:center;">
        Default: admin@university.edu / admin123
      </div>
      <% } else if("company".equals(role)){ %>
      <div style="margin-top:16px;padding:12px;background:#f5f5f5;border-radius:8px;font-size:12px;color:#888;text-align:center;">
        Sample: hr@techcorp.com / company123 (must be approved by admin)
      </div>
      <% } else { %>
      <div style="margin-top:16px;padding:12px;background:#f5f5f5;border-radius:8px;font-size:12px;color:#888;text-align:center;">
        Sample: arjun@student.edu / student123
      </div>
      <% } %>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
